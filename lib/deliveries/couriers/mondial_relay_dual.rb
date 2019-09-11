require_relative 'mondial_relay_dual/shipments/create'
require_relative 'mondial_relay_dual/pickups/create/format_params'

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
      API_ENDPOINT_TEST = 'http://connect.api.sandbox.mondialrelay.com/api/shipment'.freeze

      module_function

      def get_collection_points(country:, postcode:)
        Deliveries::Couriers::MondialRelay.get_collection_points(
          country: country,
          postcode: postcode
        )
      end

      def get_collection_point(global_point_id:)
        Deliveries::Couriers::MondialRelay.get_collection_point(global_point_id:global_point_id)
      end

      def create_shipment(sender:, receiver:, collection_point: nil, shipment_date: nil,
                          parcels:, reference_code:, remarks: nil)
        params = Deliveries::Couriers::MondialRelay::Shipments::Create::FormatParams.new(
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          collection_point: collection_point,
          reference_code: reference_code,
          remarks: remarks
        ).execute

        expedition_num = Shipments::Create.new(
          params: params
        ).execute

        delivery = Deliveries::Delivery.new(
          courier_id: 'mondial_relay_dual',
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          reference_code: reference_code,
          tracking_code: expedition_num
        )

        delivery
      end

      def create_pickup(sender:, receiver:, parcels:, reference_code:,
                        pickup_date: nil, remarks: nil)
        params = Pickups::Create::FormatParams.new(
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          reference_code: reference_code,
          pickup_date: pickup_date,
          remarks: remarks
        ).execute

        expedition_num = Shipments::Create.new(
          params: params
        ).execute

        pickup = Deliveries::Pickup.new(
          courier_id: 'mondial_relay_dual',
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          reference_code: reference_code,
          tracking_code: expedition_num,
          pickup_date: pickup_date
        )

        pickup
      end

      def shipment_info(tracking_code:, language: 'ES')
        Deliveries::Couriers::MondialRelay.shipment_info(tracking_code: tracking_code, language: language)
      end

      def pickup_info(tracking_code:, language: 'ES')
        shipment_info(tracking_code: tracking_code, language: language)
      end

      def get_label(tracking_code:, language: 'ES')
        # TODO
      end

      def get_labels(tracking_codes:, language: 'ES')
        # TODO
      end
    end
  end
end
