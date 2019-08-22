require_relative 'mondial_relay/collection_points/search/format_response'
require_relative 'mondial_relay/shipments/create'
require_relative 'mondial_relay/shipments/create/defaults'
require_relative 'mondial_relay/shipments/create/format_params'
require_relative 'mondial_relay/shipments/trace'
require_relative 'mondial_relay/shipments/trace/format_response'
require_relative 'mondial_relay/pickups/create/format_params'
require_relative 'mondial_relay/labels/generate'
require_relative 'mondial_relay/status_codes'
require_relative 'mondial_relay/utils'

module Deliveries
  module Couriers
    class MondialRelay < Deliveries::Courier
      Config = Struct.new(
        :mondial_relay_merchant,
        :mondial_relay_key
      )

      WSDL_ENDPOINT = 'http://api.mondialrelay.com/Web_Services.asmx?WSDL'.freeze

      class << self

        def api_client
          Savon.client wsdl: WSDL_ENDPOINT
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
             response_result[:stat] == '0' &&
             response_result[:points_relais].present?

            collection_points = []
            response_result[:points_relais][:point_relais_details].each do |point_params|
              collection_point_params = self::CollectionPoints::Search::FormatResponse.new(response: point_params).execute
              collection_points << Deliveries::CollectionPoint.new(collection_point_params)
            end

            collection_points
          else
            raise Deliveries::APIError.new(
              self::StatusCodes.message_for(response_result[:stat].to_i),
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

          if response_result.dig(:stat) == '0' && point_relais_details.present?
            collection_point_params = self::CollectionPoints::Search::FormatResponse.new(response: point_relais_details).execute
            Deliveries::CollectionPoint.new(collection_point_params)
          else
            raise Deliveries::APIError.new(
              self::StatusCodes.message_for(response_result.dig(:stat).to_i),
              response_result.dig(:stat)
            )
          end
        end

        def create_shipment(sender:, receiver:, collection_point: nil, shipment_date: nil,
                            parcels:, reference_code:, remarks: nil)
          params = self::Shipments::Create::FormatParams.new(
            sender: sender,
            receiver: receiver,
            parcels: parcels,
            collection_point: collection_point,
            reference_code: reference_code,
            remarks: remarks
          ).execute

          expedition_num = self::Shipments::Create.new(
            params: params
          ).execute

          delivery = Deliveries::Delivery.new(
            courier_id: 'mondial_relay',
            sender: sender,
            receiver: receiver,
            parcels: parcels,
            reference_code: reference_code,
            tracking_code: expedition_num
          )

          delivery
        end

        def create_pickup(sender:, receiver:, parcels:, reference_code:,
                          pickup_date:, remarks: nil)
          params = self::Pickups::Create::FormatParams.new(
            sender: sender,
            receiver: receiver,
            parcels: parcels,
            reference_code: reference_code,
            pickup_date: pickup_date,
            remarks: remarks
          ).execute

          expedition_num = self::Shipments::Create.new(
            params: params
          ).execute

          pickup = Deliveries::Pickup.new(
            courier_id: 'mondial_relay',
            sender: sender,
            receiver: receiver,
            parcels: parcels,
            reference_code: reference_code,
            tracking_code: expedition_num,
            pickup_date: pickup_date
          )

          pickup
        end

        def shipment_info(tracking_code:, language: 'FR')
          response = self::Shipments::Trace.new(
            tracking_code: tracking_code,
            language: language
          ).execute

          tracking_info_params = self::Shipments::Trace::FormatResponse.new(response: response).execute

          tracking_info_params = tracking_info_params.merge(tracking_code: tracking_code)
          tracking_info = Deliveries::TrackingInfo.new(tracking_info_params)

          tracking_info
        end

        def pickup_info(tracking_code:, language: 'FR')
          shipment_info(tracking_code: tracking_code, language: language)
        end

        def get_label(tracking_code:, language: 'FR')
          get_labels(tracking_codes: [tracking_code], language: language)
        end

        def get_labels(tracking_codes:, language: 'FR')
          labels_url = self::Labels::Generate.new(
            tracking_codes: tracking_codes.join(';'),
            language: language
          ).execute

          Deliveries::Label.new(
            raw: open(labels_url).read,
            url: labels_url
          )
        end

        def calculate_security_param(params)
          Digest::MD5.hexdigest(params.map { |_, v| v }.join + Deliveries::Couriers::MondialRelay.config(:mondial_relay_key)).upcase
        end
      end
    end
  end
end
