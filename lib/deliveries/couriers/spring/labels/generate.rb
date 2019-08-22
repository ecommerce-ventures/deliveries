module Deliveries
  module Couriers
    class Spring < Deliveries::Courier
      module Labels
        class Generate
          attr_accessor :tracking_codes

          def initialize(tracking_codes:)
            self.tracking_codes = [tracking_codes].flatten
          end

          def execute
            default_params = {
              "Apikey": Deliveries::Couriers::Spring.config(:api_key),
              "Command": "GetShipmentLabel",
              "Shipment": {
                "LabelFormat": "PDF",
                "TrackingNumber": ""
              }
            }

            labels = tracking_codes.map do |tracking_code|
              params = default_params.deep_merge("Shipment": { "TrackingNumber": tracking_code })
              response = Deliveries::Couriers::Spring::Request.execute(params: params)
              {
                url: response[:Shipment][:CarrierTrackingUrl],
                decoded_label: Base64.decode64(response[:Shipment][:LabelImage])
              }
            end

            file = StringIO.new
            Deliveries::Label.generate_merged_pdf(labels.map{ |label| label[:decoded_label] }).write(file)
            file.string.force_encoding('binary')

            {
              pdf: file.string.force_encoding('binary'),
              url: labels.one? ? labels.first[:url] : nil
            }
          end
        end
      end
    end
  end
end
