module Deliveries
  module Couriers
    class CorreosExpress < Deliveries::Courier
      module CollectionPoints
        class Search
          attr_accessor :postcode

          def initialize(postcode:)
            self.postcode = postcode
          end

          def execute
            auth = {
              username: Deliveries::Couriers::CorreosExpress.class_variable_get(:@@config).correos_express_user,
              password: Deliveries::Couriers::CorreosExpress.class_variable_get(:@@config).correos_express_password
            }

            headers = { "Content-Type" => "application/json;charset=UTF-8", "Accept" => "application/json" }

            response = HTTParty.post(
              api_endpoint,
              basic_auth: auth,
              body: { cod_postal: postcode }.to_json,
              headers: headers
            )

            if response.dig('tipoRespuesta') == 'KO'
              raise Deliveries::APIError.new(
                response.dig('listaErrores').first['descError'],
                response.dig('listaErrores').first['codError']
              )
            end

            response.parsed_response["oficinas"]
          end

          private

          def api_endpoint
            if CorreosExpress.live?
              CorreosExpress::COLLECTION_POINTS_ENDPOINT_LIVE
            else
              CorreosExpress::COLLECTION_POINTS_ENDPOINT_TEST
            end
          end
        end
      end
    end
  end
end
