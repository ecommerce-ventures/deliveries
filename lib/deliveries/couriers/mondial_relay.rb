require_relative 'mondial_relay/collection_points/search/format_response'
require_relative 'mondial_relay/shipments/create'
require_relative 'mondial_relay/shipments/create/defaults'
require_relative 'mondial_relay/shipments/create/format_params'
require_relative 'mondial_relay/shipments/trace'
require_relative 'mondial_relay/shipments/trace/format_response'
require_relative 'mondial_relay/pickups/create/format_params'
require_relative 'mondial_relay/labels/generate'
require_relative 'mondial_relay/status_codes'
require_relative 'mondial_relay/address'
require 'savon'

module Deliveries
  module Couriers
    module MondialRelay
      extend Courier

      Config = Struct.new(
        :mondial_relay_merchant,
        :mondial_relay_key
      )

      WSDL_ENDPOINT = 'http://api.mondialrelay.com/Web_Services.asmx?WSDL'.freeze

      module_function

      def api_client
        Savon.client wsdl: WSDL_ENDPOINT,
                     logger: Deliveries.logger,
                     log: Deliveries.debug
      end

      def get_collection_points(country:, postcode:)
        # Build params needed by web service.
        params = { 'Enseigne' => Deliveries::Couriers::MondialRelay.config(:mondial_relay_merchant),
                   'Pays' => country, 'NumPointRelais' => '', 'Ville' => '',
                   'CP' => postcode, 'Latitude' => '', 'Longitude' => '',
                   'Taille' => '', 'Poids' => '', 'Action' => '',
                   'DelaiEnvoi' => '0', 'RayonRecherche' => '', 'TypeActivite' => '', 'NACE' => '' }
        # Calculate security parameters.
        params['Security'] = calculate_security_param params

        response = api_client.call :wsi3_point_relais_recherche, message: params
        # If response returns OK stat code.
        if (response_result = response.body[:wsi3_point_relais_recherche_response][:wsi3_point_relais_recherche_result]) &&
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
                   'DelaiEnvoi' => '0', 'RayonRecherche' => '', 'TypeActivite' => '', 'NACE' => '' }

        # Calculate security parameters.
        params['Security'] = calculate_security_param params

        response = api_client.call :wsi3_point_relais_recherche, message: params

        response_result = response.body.dig(:wsi3_point_relais_recherche_response,
                                            :wsi3_point_relais_recherche_result)

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
        params = Shipments::Create::FormatParams.new(
          sender: sender.courierize(:mondial_relay),
          receiver: receiver.courierize(:mondial_relay),
          parcels: parcels,
          collection_point: collection_point,
          reference_code: reference_code,
          remarks: remarks,
          language: language
        ).execute

        tracking_code, label_url = Shipments::Create.new(
          params: params
        ).execute.values_at(:tracking_code, :label_url)

        Deliveries::Shipment.new(
          courier_id: 'mondial_relay',
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          reference_code: reference_code,
          tracking_code: tracking_code,
          shipment_date: shipment_date,
          label: Label.new(url: label_url)
        )
      end

      def create_pickup(sender:, receiver:, parcels:, reference_code:,
                        pickup_date: nil, remarks: nil, language: 'FR')
        params = Pickups::Create::FormatParams.new(
          sender: sender.courierize(:mondial_relay),
          receiver: receiver.courierize(:mondial_relay),
          parcels: parcels,
          reference_code: reference_code,
          pickup_date: pickup_date,
          remarks: remarks,
          language: language
        ).execute

        tracking_code, label_url = Shipments::Create.new(
          params: params
        ).execute.values_at(:tracking_code, :label_url)

        Deliveries::Pickup.new(
          courier_id: 'mondial_relay',
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          reference_code: reference_code,
          tracking_code: tracking_code,
          pickup_date: pickup_date,
          label: Label.new(url: label_url)
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

      def get_label(tracking_code:, language: 'FR')
        label_url = Labels::Generate.new(
          tracking_codes: tracking_code,
          language: language
        ).execute

        Deliveries::Label.new(url: label_url)
      end

      def get_labels(tracking_codes:, language: 'FR')
        labels_url = Labels::Generate.new(
          tracking_codes: tracking_codes,
          language: language
        ).execute

        Deliveries::Labels.new(url: labels_url)
      end

      def calculate_security_param(params)
        Digest::MD5.hexdigest(params.map do |_, v|
                                v
                              end.join + Deliveries::Couriers::MondialRelay.config(:mondial_relay_key)).upcase
      end
    end
  end
end
