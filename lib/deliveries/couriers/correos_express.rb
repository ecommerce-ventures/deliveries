require_relative 'correos_express/shipments/trace/format_response'
require_relative 'correos_express/shipments/trace'
require_relative 'correos_express/shipments/create/defaults'
require_relative 'correos_express/shipments/create/format_params'
require_relative 'correos_express/shipments/create'
require_relative 'correos_express/collection_points/search'
require_relative 'correos_express/collection_points/search/format_response'
require_relative 'correos_express/labels/generate'
require_relative 'correos_express/pickups/create/defaults'
require_relative 'correos_express/pickups/create/format_params'
require_relative 'correos_express/pickups/create'
require_relative 'correos_express/pickups/trace/format_response'
require_relative 'correos_express/pickups/trace'

module Deliveries
  module Couriers
    class CorreosExpress < Deliveries::Courier

      Config = Struct.new(
        :correos_express_user,
        :correos_express_password,
        :solicitante,
        :cod_rte
      )

      COLLECTION_POINTS_ENDPOINT_TEST = 'https://www.correosexpress.com/wspsc/apiRestOficina/v1/oficinas/listadoOficinasCoordenadas'.freeze
      COLLECTION_POINTS_ENDPOINT_LIVE = 'https://www.correosexpress.com/wpsc/apiRestOficina/v1/oficinas/listadoOficinasCoordenadas'.freeze
      SHIPMENTS_ENDPOINT_LIVE = 'https://www.correosexpress.com/wpsc/apiRestOficina/v1/oficinas/listadoOficinasCoordenadas'.freeze
      SHIPMENTS_ENDPOINT_TEST = 'https://test.correosexpress.com/wspsc/apiRestGrabacionEnvio/json/grabacionEnvio'.freeze
      TRACKING_INFO_ENDPOINT_LIVE = 'https://www.correosexpress.com/wpsc/apiRestSeguimientoEnvios/rest/seguimientoEnvios'.freeze
      LABELS_ENDPOINT_LIVE = 'https://www.cexpr.es/wspsc/apiRestEtiquetaTransporte/json/etiquetaTransporte'.freeze
      PICKUPS_ENDPOINT_LIVE = 'https://www.correosexpress.com/wpsc/apiRestGrabacionRecogida/json/grabarRecogida'.freeze
      PICKUPS_ENDPOINT_TEST = 'https://test.correosexpress.com/wpsn/apiRestGrabacionRecogida/json/grabarRecogida'.freeze

      SHIPMENT_TO_COLLECTION_POINT_COUNTRIES = [:es].freeze
      SHIPMENT_TO_HOME_COUNTRIES = [:es, :pt].freeze
      PICKUP_AT_COLLECTION_POINT_COUNTRIES = [:es].freeze
      PICKUP_AT_HOME_COUNTRIES = [:es, :pt].freeze

      class << self
        def configure
          @@config ||= Config.new
          yield @@config
        end

        def shipment_to_collection_point?(country:)
          SHIPMENT_TO_COLLECTION_POINT_COUNTRIES.include?(country.downcase.to_sym)
        end

        def shipment_to_home?(country:)
          SHIPMENT_TO_HOME_COUNTRIES.include?(country.downcase.to_sym)
        end

        def pickup_at_home?(country:)
          PICKUP_AT_HOME_COUNTRIES.include?(country.downcase.to_sym)
        end

        def pickup_at_collection_point?(country:)
          PICKUP_AT_COLLECTION_POINT_COUNTRIES.include?(country.downcase.to_sym)
        end

        def get_collection_points(postcode:, country: nil)
          raise Deliveries::APIError.new("Postcode cannot be null") if postcode.blank?

          collection_points = []

          points = self::CollectionPoints::Search.new(postcode: postcode).execute
          points.each do |point|
            collection_point_params = self::CollectionPoints::Search::FormatResponse.new(response: point).execute
            collection_points << Deliveries::CollectionPoint.new(collection_point_params)
          end

          collection_points
        end

        def get_collection_point(global_point_id:)
          global_point = Deliveries::CollectionPoint.parse_global_point_id(global_point_id: global_point_id)

          collection_points = get_collection_points(postcode: global_point.postcode)
          collection_point = collection_points.select{ |col| col.point_id == global_point.point_id }.first

          if collection_point.blank?
            raise Deliveries::APIError.new(
              "Collection Point not found - #{global_point.point_id}",
              1
            )
          end

          collection_point
        end

        def shipment_info(tracking_code:, language: nil)
          response = self::Shipments::Trace.new(
            tracking_code: tracking_code
          ).execute

          tracking_info_params = self::Shipments::Trace::FormatResponse.new(response: response).execute
          Deliveries::TrackingInfo.new(tracking_info_params)
        end

        def pickup_info(tracking_code:, language: nil)
          response = self::Pickups::Trace.new(
            tracking_code: tracking_code
          ).execute

          tracking_info_params = self::Pickups::Trace::FormatResponse.new(response: response).execute

          Deliveries::TrackingInfo.new(tracking_info_params)
        end

        def get_label(tracking_code:, language: nil)
          pdf = self::Labels::Generate.new(
            tracking_codes: tracking_code
          ).execute

          Deliveries::Label.new(
            raw: pdf,
            url: nil
          )
        end

        def get_labels(tracking_codes:, language: nil)
          pdf = self::Labels::Generate.new(
            tracking_codes: tracking_codes
          ).execute

          Deliveries::Label.new(
            raw: pdf,
            url: nil
          )
        end

        def create_shipment(sender:, receiver:, collection_point: nil, shipment_date: nil,
                            parcels:, reference_code:, remarks: nil)
          self::Shipments::Create.new(
            sender: sender,
            receiver: receiver,
            collection_point: collection_point,
            shipment_date: shipment_date,
            parcels: parcels,
            reference_code: reference_code,
            remarks: remarks
          ).execute
        end

        def create_pickup(sender:, receiver:, parcels:,reference_code:,
                          pickup_date:, remarks: nil)
          params = self::Pickups::Create::FormatParams.new(
            sender: sender,
            receiver: receiver,
            parcels: parcels,
            reference_code: reference_code,
            pickup_date: pickup_date,
            remarks: remarks
          ).execute

          pickup_number = self::Pickups::Create.new(params: params).execute

          Deliveries::Pickup.new(
            courier_id: 'correos_express',
            sender: sender,
            receiver: receiver,
            parcels: parcels,
            reference_code: reference_code,
            tracking_code: pickup_number,
            pickup_date: pickup_date
          )
        end
      end
    end
  end
end
