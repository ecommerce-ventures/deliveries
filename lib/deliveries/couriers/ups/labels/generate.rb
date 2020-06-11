module Deliveries
  module Couriers
    module Ups
      module Labels
        class Generate
          include JsonRequest
          include LabelUtils

          API_VERSION = 'V1903'.freeze

          attr_accessor :tracking_code

          def initialize(tracking_code:)
            self.tracking_code = tracking_code
          end

          def execute
            request = {
              LabelRecoveryRequest: {
                TrackingNumber: tracking_code,
                ShipperNumber: Ups.config(:account_number),
                LabelSpecification: {
                  LabelImageFormat: {
                    Code: 'GIF'
                  }
                },
                LabelDelivery: {
                  LabelLinkIndicator: ''
                }
              }
            }

            response = call request

            label_url = response.dig(:LabelRecoveryResponse, :LabelResults, :LabelImage, :URL)
            label_encoded = response.dig(:LabelRecoveryResponse, :LabelResults, :LabelImage, :GraphicImage)
            raise Error, 'Cannot obtain encoded label' if label_encoded.nil?

            label_gif = Base64.decode64(label_encoded).force_encoding('binary')
            label_pdf = image2pdf label_gif, height: 4

            {
              raw: label_pdf,
              url: label_url
            }
          end

          private

          def api_endpoint
            if Ups.live?
              "https://onlinetools.ups.com/ship/#{API_VERSION}/shipments/labels"
            else
              "https://wwwcie.ups.com/ship/#{API_VERSION}/shipments/labels"
            end
          end
        end
      end
    end
  end
end
