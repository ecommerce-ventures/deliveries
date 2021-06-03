module Deliveries
  module Couriers
    module CorreosExpress
      module CollectionPoints
        class Search
          include HTTParty

          attr_accessor :postcode

          def initialize(postcode:)
            self.postcode = postcode
          end

          def execute
            auth = {
              username: CorreosExpress.config(:username),
              password: CorreosExpress.config(:password)
            }

            headers = { 'Content-Type' => 'application/json;charset=UTF-8', 'Accept' => 'application/json' }

            response = self.class.post(
              api_endpoint,
              basic_auth: auth,
              body: { cod_postal: postcode }.to_json,
              headers: headers,
              debug_output: Deliveries.debug ? Deliveries.logger : nil
            )
            parsed_response = JSON.parse(response.body)

            if parsed_response['tipoRespuesta'] == 'KO'
              raise Deliveries::APIError.new(
                parsed_response['listaErrores'].first['descError'],
                parsed_response['listaErrores'].first['codError']
              )
            end

            parsed_response['oficinas']
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
