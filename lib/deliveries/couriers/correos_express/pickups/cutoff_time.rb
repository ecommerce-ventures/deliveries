module Deliveries
  module Couriers
    module CorreosExpress
      module Pickups
        class CutoffTime
          include HTTParty

          attr_accessor :country, :postcode

          def initialize(country:, postcode:)
            self.country = country
            self.postcode = postcode
          end

          def execute
            auth = {
              username: CorreosExpress.config(:username),
              password: CorreosExpress.config(:password)
            }

            params = FormatParams.new(
              country: country,
              postcode: postcode
            ).execute

            response = self.class.post(
              api_endpoint,
              basic_auth: auth,
              body: params,
              headers: headers,
              debug_output: Deliveries.debug ? Deliveries.logger : nil
            )
            if response.success?
              parsed_response = JSON.parse(response.body, symbolize_names: true)
              if parsed_response.dig(:codError) == 0 && parsed_response.dig(:horaCorte).present?
                parsed_response.dig(:horaCorte)
              else
                raise Deliveries::APIError.new(
                  parsed_response.dig(:mensError),
                  parsed_response.dig(:codError)
                )
              end
            else
              raise Deliveries::Error
            end
          end

          private

          def api_endpoint
            CorreosExpress::CUTOFF_TIME_ENDPOINT_LIVE
          end

          def headers
            { "Content-Type" => "application/json" }
          end
        end
      end
    end
  end
end
