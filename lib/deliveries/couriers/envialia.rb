require_relative 'envialia/shipments/create'

module Deliveries
  module Couriers
    module Envialia
      extend Courier

      Config = Struct.new(
        :username,
        :password,
        :agency_code
      )

      LOGIN_ENDPOINT = 'http://wstest.envialia.com:9085/SOAP?service=LoginService'.freeze

      module_function

      def login
        response = HTTParty.post(
          LOGIN_ENDPOINT,
          body: body,
          headers: headers
        )

        parsed_response = Hash.from_xml(response)

        parsed_response.dig("Envelope", "Header", "ROClientIDHeader", "ID")
      end

      def create_shipment(sender:, receiver:, parcels:, reference_code:, collection_point: nil, shipment_date: nil, remarks: nil, **)
        Shipments::Create.new(
          sender: sender,
          receiver: receiver,
          collection_point: collection_point,
          shipment_date: shipment_date,
          parcels: parcels,
          reference_code: reference_code,
          remarks: remarks
        ).execute
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
