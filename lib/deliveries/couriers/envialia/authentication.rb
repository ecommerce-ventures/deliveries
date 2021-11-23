require 'httparty'

module Deliveries
  module Couriers
    module Envialia
      module Authentication
        include HTTParty

        def session_id
          response = HTTParty.post(
            login_endpoint,
            body: login_body,
            headers: login_headers,
            debug_output: Deliveries.debug ? Deliveries.logger : nil
          )

          raise Deliveries::ClientError unless response.success?

          unless Envialia.live?
            response = Hash.from_xml(response)
          end

          response.dig("Envelope", "Header", "ROClientIDHeader", "ID")
        end

        def login_body
          <<~XML
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
              <soapenv:Body>
                <tns:LoginWSService___LoginCli2 xmlns:tns="http://tempuri.org/">
                  <strCodAge>#{Deliveries.courier(:envialia).config(:agency_code)}</strCodAge>
                  <strCliente>#{Deliveries.courier(:envialia).config(:username)}</strCliente>
                  <strPass>#{Deliveries.courier(:envialia).config(:password)}</strPass>
                </tns:LoginWSService___LoginCli2>
              </soapenv:Body>
            </soapenv:Envelope>
          XML
        end

        def login_headers
          { "Content-Type"=>"text/json; charset='UTF-8'" }
        end

        def login_endpoint
          if Envialia.live?
            Envialia::ENVIALIA_LOGIN_ENDPOINT_LIVE
          else
            Envialia::ENVIALIA_LOGIN_ENDPOINT_TEST
          end
        end
      end
    end
  end
end
