module Deliveries
  module Couriers
    module Spring
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
              sender: sender.courierize(:spring),
              receiver: receiver.courierize(:spring),
              parcels: parcels,
              reference_code: reference_code
            ).execute

            response = Deliveries::Couriers::Spring::Request.execute(params: params)

            tracking_code = response[:Shipment][:TrackingNumber]
            label = Label.new(
              url: response[:Shipment][:CarrierTrackingUrl],
              raw: Base64.decode64(response[:Shipment][:LabelImage]).force_encoding('binary')
            )

            Deliveries::Delivery.new(
              courier_id: Deliveries::Couriers::Spring::COURIER_ID,
              sender: sender,
              receiver: receiver,
              parcels: parcels,
              reference_code: reference_code,
              tracking_code: tracking_code,
              label: label
            )
          end
        end
      end
    end
  end
end
