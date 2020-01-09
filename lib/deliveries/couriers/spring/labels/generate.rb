module Deliveries
  module Couriers
    module Spring
      module Labels
        class Generate
          attr_accessor :tracking_code

          def initialize(tracking_code:)
            self.tracking_code = tracking_code
          end

          def execute
            params = {
              "Apikey": Deliveries::Couriers::Spring.config(:api_key),
              "Command": "GetShipmentLabel",
              "Shipment": {
                "LabelFormat": "PDF",
                "TrackingNumber": tracking_code
              }
            }

            response = Deliveries::Couriers::Spring::Request.execute(params: params)

            {
              url: response[:Shipment][:CarrierTrackingUrl],
              decoded_label: Base64.decode64(response[:Shipment][:LabelImage]).force_encoding('binary')
            }
          end
        end
      end
    end
  end
end
