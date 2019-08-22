module Deliveries
  module Couriers
    class CorreosExpress < Deliveries::Courier
      module Pickups
        class Trace
          WSDL_PATH = Rails.root + "lib/deliveries/couriers/correos_express/pickups/trace/correos.wsdl".freeze

          attr_accessor :tracking_code

          def initialize(tracking_code:)
            self.tracking_code = tracking_code
          end

          def execute
            # Load the users from production environment because the dev api does not work
            if Deliveries.test?
              solicitante = YAML.load_file('config/deliveries/correos_express.yml')['production']['solicitante']
              cod_rte = YAML.load_file('config/deliveries/correos_express.yml')['production']['cod_rte']
            else
              solicitante = Deliveries::Couriers::CorreosExpress.config(:solicitante)
              cod_rte = Deliveries::Couriers::CorreosExpress.config(:cod_rte)
            end

            params = {
              "solicitante" => solicitante,
              "dato" => tracking_code,
              "password" => "",
              "codCliente" => cod_rte
            }

            basic_auth = [
              Deliveries::Couriers::CorreosExpress.config(:correos_express_user),
              Deliveries::Couriers::CorreosExpress.config(:correos_express_password)
            ]

            client = Savon.client wsdl: WSDL_PATH,
                                  basic_auth: basic_auth

            response = client.call(:seguimiento_recogida, message: params)

            response_result = response.body.dig(:seguimiento_recogida_response).dig(:return)
            if response_result && response_result.dig(:recogida).present?
              response_result
            else
              raise Deliveries::APIError.new(response_result.dig(:mensaje_retorno).to_s.strip)
            end
          end
        end
      end
    end
  end
end
