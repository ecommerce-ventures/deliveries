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
              username: Deliveries::Couriers::CorreosExpress.config(:correos_express_user),
              password: Deliveries::Couriers::CorreosExpress.config(:correos_express_password)
            }

            headers = { "Content-Type" => "application/json;charset=UTF-8", "Accept" => "application/json" }

            response = HTTParty.post(
              api_endpoint,
              basic_auth: auth,
              body: { cod_postal: postcode }.to_json,
              headers: headers
            )
            parsed_response = JSON.parse(response.body)

            if parsed_response.dig('tipoRespuesta') == 'KO'
              raise Deliveries::APIError.new(
                parsed_response.dig('listaErrores').first['descError'],
                parsed_response.dig('listaErrores').first['codError']
              )
            end

            parsed_response["oficinas"]
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
