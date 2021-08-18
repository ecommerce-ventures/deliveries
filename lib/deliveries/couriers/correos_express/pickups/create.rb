require 'httparty'

module Deliveries
  module Couriers
    module CorreosExpress
      module Pickups
        class Create
          include HTTParty

          attr_accessor :params

          def initialize(params:)
            self.params = params
          end

          def execute
            auth = {
              username: CorreosExpress.config(:username),
              password: CorreosExpress.config(:password)
            }

            response = self.class.post(
              api_endpoint,
              basic_auth: auth,
              body: params,
              headers: headers,
              debug_output: Deliveries.debug ? Deliveries.logger : nil
            )
            raise ClientError, "Failed with status code #{response.code}" unless response.success?

            parsed_response = JSON.parse(response.body, symbolize_names: true)
            if parsed_response[:codigoRetorno]&.zero? && parsed_response[:numRecogida].present?
              parsed_response[:numRecogida]
            else
              exception_class =
                case parsed_response[:codigoRetorno]
                when 105 then InvalidDateError
                when 154 then InvalidTimeIntervalError
                else APIError
                end

              raise exception_class.new(
                parsed_response[:mensajeRetorno],
                parsed_response[:codigoRetorno]
              )
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
            { 'Content-Type' => 'application/json' }
          end
        end
      end
    end
  end
end
