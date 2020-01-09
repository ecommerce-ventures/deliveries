require_relative 'mondial_relay_dual/shipments/create'
require_relative 'mondial_relay_dual/shipments/create/format_params'
require_relative 'mondial_relay_dual/pickups/create/format_params'
require_relative 'mondial_relay_dual/address'

module Deliveries
  module Couriers
    module MondialRelayDual
      extend Courier

      Config = Struct.new(
        :dual_carrier_login,
        :dual_carrier_password,
        :dual_carrier_customer_id
      )

      API_ENDPOINT_LIVE = 'https://connect-api.mondialrelay.com/api/shipment'.freeze
      API_ENDPOINT_TEST = 'https://connect-api-sandbox.mondialrelay.com/api/shipment'.freeze

      module_function

      def get_collection_points(country:, postcode:)
        MondialRelay.get_collection_points(
          country: country,
          postcode: postcode
        )
      end

      def get_collection_point(global_point_id:)
        MondialRelay.get_collection_point(global_point_id: global_point_id)
      end

      def create_shipment(sender:, receiver:, collection_point: nil, shipment_date: nil,
                          parcels:, reference_code:, remarks: nil, language: nil)
        params = Shipments::Create::FormatParams.new(
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          collection_point: collection_point,
          reference_code: reference_code,
          remarks: remarks,
          language: language
        ).execute

        tracking_code, pdf_url = Shipments::Create.new(
          params: params
        ).execute.values_at(:tracking_code, :pdf_url)

        Deliveries::Shipment.new(
          courier_id: 'mondial_relay_dual',
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          reference_code: reference_code,
          tracking_code: tracking_code,
          shipment_date: shipment_date,
          label: Label.new(url: pdf_url)
        )
      end

      def create_pickup(sender:, receiver:, parcels:, reference_code:,
                        pickup_date: nil, remarks: nil, language: nil)
        params = Pickups::Create::FormatParams.new(
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          reference_code: reference_code,
          remarks: remarks,
          language: language
        ).execute

        tracking_code, pdf_url = Shipments::Create.new(
          params: params
        ).execute.values_at(:tracking_code, :pdf_url)

        Deliveries::Pickup.new(
          courier_id: 'mondial_relay_dual',
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          reference_code: reference_code,
          tracking_code: tracking_code,
          pickup_date: pickup_date,
          label: Label.new(url: pdf_url)
        )
      end

      def shipment_info(tracking_code:, language: nil)
        MondialRelay.shipment_info(tracking_code: tracking_code, language: language)
      end

      def pickup_info(tracking_code:, language: nil)
        MondialRelay.pickup_info(tracking_code: tracking_code, language: language)
      end

      def get_label(**)
        raise NotImplementedError, 'This courier does not support get_label operation'
      end

      def get_labels(**)
        raise NotImplementedError, 'This courier does not support get_labels operation'
      end
    end
  end
end
