require_relative 'mondial_relay/collection_points/search/format_response'
require_relative 'mondial_relay/shipments/trace'
require_relative 'mondial_relay/shipments/trace/format_response'
require_relative 'mondial_relay/status_codes'
require 'savon'

module Deliveries
  module Couriers
    module MondialRelay
      extend Courier

      Config = Struct.new(
        :mondial_relay_merchant,
        :mondial_relay_key
      )

      WSDL_ENDPOINT = 'https://api.mondialrelay.com/Web_Services.asmx?WSDL'.freeze

      module_function

      def api_client
        Savon.client(
          wsdl: WSDL_ENDPOINT,
          logger: Deliveries.logger,
          log: Deliveries.debug,
          follow_redirects: true
        )
      end

      def get_collection_points(country:, postcode:)
        # Build params needed by web service.
        params = { 'Enseigne' => Deliveries::Couriers::MondialRelay.config(:mondial_relay_merchant),
                   'Pays' => country, 'NumPointRelais' => '', 'Ville' => '',
                   'CP' => postcode, 'Latitude' => '', 'Longitude' => '',
                   'Taille' => '', 'Poids' => '', 'Action' => '',
                   'DelaiEnvoi' => '0', 'RayonRecherche' => '', 'TypeActivite' => '', 'NACE' => '',
                   'NombreResultats' => '30' }
        # Calculate security parameters.
        params['Security'] = calculate_security_param params

        response = api_client.call :wsi4_point_relais_recherche, message: params

        # If response returns OK stat code.
        if (response_result = response.body[:wsi4_point_relais_recherche_response][:wsi4_point_relais_recherche_result]) &&
           response_result[:stat] == '0'

          collection_points = []
          [response_result.dig(:points_relais, :point_relais_details)].flatten.compact.each do |point_params|
            collection_point_params = CollectionPoints::Search::FormatResponse.new(response: point_params).execute
            collection_points << Deliveries::CollectionPoint.new(**collection_point_params)
          end

          collection_points
        else
          raise Deliveries::APIError.new(
            StatusCodes.message_for(response_result[:stat].to_i),
            response_result[:stat]
          )
        end
      end

      def get_collection_point(global_point_id:)
        global_point = Deliveries::CollectionPoint.parse_global_point_id(global_point_id: global_point_id)

        params = { 'Enseigne' => Deliveries::Couriers::MondialRelay.config(:mondial_relay_merchant),
                   'Pays' => global_point.country, 'NumPointRelais' => global_point.point_id, 'Ville' => '',
                   'CP' => '', 'Latitude' => '', 'Longitude' => '',
                   'Taille' => '', 'Poids' => '', 'Action' => '',
                   'DelaiEnvoi' => '0', 'RayonRecherche' => '', 'TypeActivite' => '', 'NACE' => '',
                   'NombreResultats' => '1' }

        # Calculate security parameters.
        params['Security'] = calculate_security_param params

        response = api_client.call :wsi4_point_relais_recherche, message: params

        response_result = response.body.dig(:wsi4_point_relais_recherche_response,
                                            :wsi4_point_relais_recherche_result)

        point_relais_details = response_result.dig(:points_relais, :point_relais_details)

        if response_result[:stat] == '0' && point_relais_details.present?
          collection_point_params = CollectionPoints::Search::FormatResponse.new(response: point_relais_details).execute
          Deliveries::CollectionPoint.new(**collection_point_params)
        else
          raise Deliveries::APIError.new(
            StatusCodes.message_for(response_result[:stat].to_i),
            response_result[:stat]
          )
        end
      end

      def create_shipment(sender:, receiver:, parcels:, reference_code:, collection_point: nil, shipment_date: nil, remarks: nil, language: 'FR')
        MondialRelayDual.create_shipment(
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          reference_code: reference_code,
          collection_point: collection_point,
          shipment_date: shipment_date,
          remarks: remarks,
          language: language
        )
      end

      def create_pickup(sender:, receiver:, parcels:, reference_code:,
                        pickup_date: nil, remarks: nil, language: 'FR')
        MondialRelayDual.create_pickup(
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          reference_code: reference_code,
          pickup_date: pickup_date,
          remarks: remarks,
          language: language
        )
      end

      def shipment_info(tracking_code:, language: 'FR')
        response = Shipments::Trace.new(
          tracking_code: tracking_code,
          language: language
        ).execute

        tracking_info_params = Shipments::Trace::FormatResponse.new(response: response).execute

        tracking_info_params = tracking_info_params.merge(tracking_code: tracking_code)
        Deliveries::TrackingInfo.new(**tracking_info_params)
      end

      def pickup_info(tracking_code:, language: 'FR')
        shipment_info(tracking_code: tracking_code, language: language)
      end

      def get_label(**)
        raise NotImplementedError, 'This courier does not support get_label operation'
      end

      def get_labels(**)
        raise NotImplementedError, 'This courier does not support get_labels operation'
      end

      def calculate_security_param(params)
        Digest::MD5.hexdigest(params.map do |_, v|
                                v
                              end.join + Deliveries::Couriers::MondialRelay.config(:mondial_relay_key)).upcase
      end
    end
  end
end
