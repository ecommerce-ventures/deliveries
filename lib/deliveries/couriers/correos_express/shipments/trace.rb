module Deliveries
  module Couriers
    class CorreosExpress < Deliveries::Courier
      module Shipments
        class Trace
          attr_accessor :tracking_code

          def initialize(tracking_code:)
            self.tracking_code = tracking_code
          end

          def execute
            auth = {
              username: Deliveries::Couriers::CorreosExpress.class_variable_get(:@@config).correos_express_user,
              password: Deliveries::Couriers::CorreosExpress.class_variable_get(:@@config).correos_express_password
            }
            # Load the solicitante key from production environment because the dev api does not work
            solicitante = YAML.load_file('config/deliveries/correos_express.yml')['production']['solicitante']

            xml = "<?xml version='1.0'?>
              <SeguimientoEnviosRequest xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
              xsi:noNamespaceSchemaLocation='SeguimientoEnviosRequest.xsd'>
                                <Solicitante>#{solicitante}</Solicitante>
                                <Dato>#{tracking_code}</Dato>
              </SeguimientoEnviosRequest>"

            response = HTTParty.post(api_endpoint, basic_auth: auth, body: xml, headers: { "Content-Type" => "application/xml" })

            raise Deliveries::ClientError unless response.success?

            result = Hash.from_xml response.force_encoding(Encoding::ISO_8859_1).encode(Encoding::UTF_8)
            if result.dig("SeguimientoEnviosResponse").dig("Error") == "0"
              result["SeguimientoEnviosResponse"]
            else
              raise Deliveries::APIError.new(
                result.dig("SeguimientoEnviosResponse").dig("MensajeError"),
                result.dig("SeguimientoEnviosResponse").dig("Error")
              )
            end
          end

          private

          def api_endpoint
            CorreosExpress::TRACKING_INFO_ENDPOINT_LIVE
          end
        end
      end
    end
  end
end
