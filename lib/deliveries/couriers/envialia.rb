require_relative 'envialia/shipments/create'
require_relative 'envialia/pickups/create'
require_relative 'envialia/authentication'

module Deliveries
  module Couriers
    module Envialia
      extend Courier
      extend Authentication

      Config = Struct.new(
        :username,
        :password,
        :agency_code
      )

      module_function

      def create_shipment(sender:, receiver:, parcels:, reference_code:, collection_point: nil, shipment_date: nil, remarks: nil, **)
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

      def create_pickup(sender:, receiver:, parcels:, reference_code:, pickup_date: nil, remarks: nil, tracking_code: nil, **)
        Pickups::Create.new(
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          reference_code: reference_code,
          pickup_date: pickup_date,
          remarks: remarks,
          tracking_code: tracking_code
        ).execute
      end
    end
  end
end
