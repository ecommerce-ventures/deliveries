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
require_relative 'correos_express/pickups/cutoff_time/format_params'
require_relative 'correos_express/pickups/cutoff_time'
require_relative 'correos_express/address'

module Deliveries
  module Couriers
    module CorreosExpress
      extend Courier

      Config = Struct.new(
        :username,
        :password,
        :client_code,
        :shipment_sender_code,
        :pickup_receiver_code,
        :countries
      )

      COLLECTION_POINTS_ENDPOINT_TEST = 'https://www.correosexpress.com/wspsc/apiRestOficina/v1/oficinas/listadoOficinasCoordenadas'.freeze
      COLLECTION_POINTS_ENDPOINT_LIVE = 'https://www.correosexpress.com/wpsc/apiRestOficina/v1/oficinas/listadoOficinasCoordenadas'.freeze
      SHIPMENTS_ENDPOINT_LIVE = 'https://www.correosexpress.com/wpsc/apiRestGrabacionEnvio/json/grabacionEnvio'.freeze
      SHIPMENTS_ENDPOINT_TEST = 'https://test.correosexpress.com/wspsc/apiRestGrabacionEnvio/json/grabacionEnvio'.freeze
      TRACKING_INFO_ENDPOINT_LIVE = 'https://www.correosexpress.com/wpsc/apiRestSeguimientoEnvios/rest/seguimientoEnvios'.freeze
      TRACKING_INFO_ENDPOINT_TEST = 'https://test.correosexpress.com/wspsc/apiRestSeguimientoEnvios/rest/seguimientoEnvios'.freeze
      LABELS_ENDPOINT_LIVE = 'https://www.cexpr.es/wspsc/apiRestEtiquetaTransporte/json/etiquetaTransporte'.freeze
      LABELS_ENDPOINT_TEST = 'https://www.test.cexpr.es/wsps/apiRestEtiquetaTransporte/json/etiquetaTransporte'.freeze
      PICKUPS_ENDPOINT_LIVE = 'https://www.correosexpress.com/wpsc/apiRestGrabacionRecogida/json/grabarRecogida'.freeze
      PICKUPS_ENDPOINT_TEST = 'https://test.correosexpress.com/wpsn/apiRestGrabacionRecogida/json/grabarRecogida'.freeze
      CUTOFF_TIME_ENDPOINT_LIVE = 'https://www.correosexpress.com/wpsc/apiRestGrabacionRecogida/json/horaCorte'.freeze

      module_function

      def get_collection_points(postcode:, country: nil)
        raise Deliveries::APIError.new("Postcode cannot be null") if postcode.blank?

        collection_points = []

        points = CollectionPoints::Search.new(postcode: postcode).execute
        points.each do |point|
          collection_point_params = CollectionPoints::Search::FormatResponse.new(response: point).execute
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

      def shipment_info(tracking_code:, **)
        response = Shipments::Trace.new(
          tracking_code: tracking_code
        ).execute

        tracking_info_params = Shipments::Trace::FormatResponse.new(response: response).execute
        Deliveries::TrackingInfo.new(tracking_info_params)
      end

      def pickup_info(tracking_code:, **)
        response = Pickups::Trace.new(
          tracking_code: tracking_code
        ).execute

        tracking_info_params = Pickups::Trace::FormatResponse.new(response: response).execute

        Deliveries::TrackingInfo.new(tracking_info_params)
      end

      def get_label(tracking_code:, **)
        pdf = Labels::Generate.new(
          tracking_codes: tracking_code
        ).execute.first

        Deliveries::Label.new(raw: pdf)
      end

      def get_labels(tracking_codes:, **)
        labels = Deliveries::Labels.new

        Labels::Generate.new(
          tracking_codes: tracking_codes
        ).execute.each do |pdf|
          labels << pdf
        end

        labels
      end

      def create_shipment(sender:, receiver:, collection_point: nil, shipment_date: nil,
                          parcels:, reference_code:, remarks: nil, **)
        Shipments::Create.new(
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
                        pickup_date: nil, remarks: nil, **)
        time_interval = nil
        begin
          params = Pickups::Create::FormatParams.new(
            sender: sender.courierize(:correos_express),
            receiver: receiver.courierize(:correos_express),
            parcels: parcels,
            reference_code: reference_code,
            pickup_date: pickup_date,
            remarks: remarks,
            time_interval: time_interval
          ).execute

          pickup_number = Pickups::Create.new(params: params).execute
        rescue InvalidTimeIntervalError => e
          raise e if time_interval

          if (cutoff_time = e.message[/\b(\d+):\d{2}\z/, 1])
            time_interval = 9..cutoff_time.to_i
            retry
          else
            raise e
          end
        end

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
