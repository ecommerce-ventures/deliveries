module Deliveries
  module Couriers
    class Spring < Deliveries::Courier
      module Request
        module_function

        def execute(params:)
          response = HTTParty.post(
            endpoint,
            body: params.to_json,
            headers: headers
          )
          raise Deliveries::ClientError unless response.success?

          parsed_response = JSON.parse(response.body, symbolize_names: true)
          error_level = parsed_response[:ErrorLevel]

          if error_level.zero?
            parsed_response
          else
            raise Deliveries::APIError.new(
              parsed_response[:Error],
              error_level
            )
          end
        end

        def headers
          { "Content-Type" => "text/json; charset='UTF-8'" }
        end

        def endpoint
          if Spring.live?
            Spring::ENDPOINT_LIVE
          else
            Spring::ENDPOINT_TEST
          end
        end
      end
    end
  end
end
