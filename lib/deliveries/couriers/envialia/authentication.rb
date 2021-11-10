module Deliveries
  module Couriers
    module Envialia
      module Authentication

        LOGIN_ENDPOINT = 'http://wstest.envialia.com:9085/SOAP?service=LoginService'.freeze

        def login
          response = HTTParty.post(
            LOGIN_ENDPOINT,
            body: body,
            headers: headers
          )

          parsed_response = Hash.from_xml(response)

          parsed_response.dig("Envelope", "Header", "ROClientIDHeader", "ID")
        end

        def body
          "<?xml version='1.0' encoding='utf-8'?>
            <soap:Envelope
              xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'
              xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
              xmlns:xsd='http://www.w3.org/2001/XMLSchema'>
              <soap:Body>
                <LoginWSService___LoginCli2>
                <strCodAge>#{Deliveries.courier(:envialia).config(:agency_code)}</strCodAge>
                <strCliente>#{Deliveries.courier(:envialia).config(:username)}</strCliente>
                <strPass>#{Deliveries.courier(:envialia).config(:password)}</strPass>
                </LoginWSService___LoginCli2>
              </soap:Body>
          </soap:Envelope>"
        end

        def headers
          { "Content-Type"=>"text/json; charset='UTF-8'" }
        end
      end
    end
  end
end
