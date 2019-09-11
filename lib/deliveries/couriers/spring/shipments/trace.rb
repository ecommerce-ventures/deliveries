module Deliveries
  module Couriers
    module Spring
      module Shipments
        class Trace
          attr_accessor :tracking_code

          def initialize(tracking_code:)
            self.tracking_code = tracking_code
          end

          def execute
            params = {
              "Apikey": Deliveries::Couriers::Spring.config(:api_key),
              "Command": "TrackShipment",
              "Shipment": {
                "TrackingNumber": tracking_code
              }
            }

            response = Deliveries::Couriers::Spring::Request.execute(params: params)

            response[:Shipment]
          end
        end
      end
    end
  end
end
