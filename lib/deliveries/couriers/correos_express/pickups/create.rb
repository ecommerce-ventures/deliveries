module Deliveries
  module Couriers
    class CorreosExpress < Deliveries::Courier
      module Pickups
        class Create
          attr_accessor :params

          def initialize(params:)
            self.params = params
          end

          def execute
            auth = {
              username: Deliveries::Couriers::CorreosExpress.class_variable_get(:@@config).correos_express_user,
              password: Deliveries::Couriers::CorreosExpress.class_variable_get(:@@config).correos_express_password
            }

            response = HTTParty.post(api_endpoint, basic_auth: auth, body: params, headers: headers)
            if response.success?
              parsed_response = JSON.parse(response.body, symbolize_names: true)
              if parsed_response.dig(:codError) == 0 && parsed_response.dig(:numRecogida).present?
                parsed_response.dig(:numRecogida)
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
            if CorreosExpress.live?
              CorreosExpress::PICKUPS_ENDPOINT_LIVE
            else
              CorreosExpress::PICKUPS_ENDPOINT_TEST
            end
          end

          def headers
            { "Content-Type" => "application/json" }
          end
        end
      end
    end
  end
end
