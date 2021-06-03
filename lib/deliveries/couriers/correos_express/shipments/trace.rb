module Deliveries
  module Couriers
    module CorreosExpress
      module Shipments
        class Trace
          include HTTParty

          attr_accessor :tracking_code

          def initialize(tracking_code:)
            self.tracking_code = tracking_code
          end

          def execute
            auth = {
              username: CorreosExpress.config(:username),
              password: CorreosExpress.config(:password)
            }
            solicitante = CorreosExpress.config(:client_code)

            xml = "<?xml version='1.0'?>
              <SeguimientoEnviosRequest xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
              xsi:noNamespaceSchemaLocation='SeguimientoEnviosRequest.xsd'>
                                <Solicitante>#{solicitante}</Solicitante>
                                <Dato>#{tracking_code}</Dato>
              </SeguimientoEnviosRequest>"

            response = self.class.post(
              api_endpoint,
              basic_auth: auth,
              body: xml,
              headers: { 'Content-Type' => 'application/xml' },
              debug_output: Deliveries.debug ? Deliveries.logger : nil
            )

            raise Deliveries::ClientError unless response.success?

            result = Hash.from_xml response.force_encoding(Encoding::ISO_8859_1).encode(Encoding::UTF_8)
            if result['SeguimientoEnviosResponse']['Error'] == '0'
              result['SeguimientoEnviosResponse']
            else
              raise Deliveries::APIError.new(
                result['SeguimientoEnviosResponse']['MensajeError'],
                result['SeguimientoEnviosResponse']['Error']
              )
            end
          end

          private

          def api_endpoint
            if CorreosExpress.live?
              CorreosExpress::TRACKING_INFO_ENDPOINT_LIVE
            else
              CorreosExpress::TRACKING_INFO_ENDPOINT_TEST
            end
          end
        end
      end
    end
  end
end
