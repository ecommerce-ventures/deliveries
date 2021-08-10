module Deliveries
  module Couriers
    module CorreosExpress
      module Pickups
        class Trace
          WSDL_LIVE_PATH = File.dirname(__FILE__) + 'lib/deliveries/couriers/correos_express/pickups/trace/correos.wsdl'.freeze
          WSDL_TEST_PATH = File.dirname(__FILE__) + 'lib/deliveries/couriers/correos_express/pickups/trace/correos.test.wsdl'.freeze

          attr_accessor :tracking_code

          def initialize(tracking_code:)
            self.tracking_code = tracking_code
          end

          def execute
            params = {
              'solicitante' => CorreosExpress.config(:client_code),
              'dato' => tracking_code,
              'password' => '',
              'codCliente' => CorreosExpress.config(:pickup_receiver_code)
            }

            basic_auth = [
              CorreosExpress.config(:username),
              CorreosExpress.config(:password)
            ]

            client = Savon.client wsdl: CorreosExpress.live? ? WSDL_LIVE_PATH : WSDL_TEST_PATH,
                                  basic_auth: basic_auth,
                                  logger: Deliveries.logger,
                                  log: Deliveries.debug

            response = client.call(:seguimiento_recogida, message: params)

            response_result = response.body[:seguimiento_recogida_response][:return]
            unless response_result && response_result[:recogida].present?
              raise Deliveries::APIError,
                    response_result[:mensaje_retorno].to_s.strip
            end

            response_result
          end
        end
      end
    end
  end
end
