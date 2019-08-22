module Deliveries
  module Couriers
    class Spring < Deliveries::Courier
      module Shipments
        class Create
          attr_accessor :sender, :receiver, :parcels, :reference_code

          def initialize(sender:, receiver:, parcels:, reference_code:)
            self.sender = sender
            self.receiver = receiver
            self.parcels = parcels
            self.reference_code = reference_code
          end

          def execute
            params = Deliveries::Couriers::Spring::Shipments::Create::FormatParams.new(
              sender: sender,
              receiver: receiver,
              parcels: parcels,
              reference_code: reference_code
            ).execute

            response = Deliveries::Couriers::Spring::Request.execute(params: params)

            Deliveries::Delivery.new(
              courier_id: Deliveries::Couriers::Spring::ID,
              sender: sender,
              receiver: receiver,
              parcels: parcels,
              reference_code: reference_code,
              tracking_code: response[:Shipment][:TrackingNumber]
            )
          end
        end
      end
    end
  end
end
