module Deliveries
  module Couriers
    module Envialia
      extend Courier

      Config = Struct.new(
        :username,
        :password,
        :agency_code
      )

      API_ENDPOINT = 'http://wstest.envialia.com:9085/SOAP?service=LoginService'.freeze

      module_function

      def login
        HTTParty.post(
          API_ENDPOINT,
          body: body,
          headers: headers
        )
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
