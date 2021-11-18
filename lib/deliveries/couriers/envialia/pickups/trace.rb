require 'httparty'

module Deliveries
  module Couriers
    module Envialia
      module Pickups
        class Trace
          include HTTParty
          extend Authentication

          attr_accessor :tracking_code

          API_URL = 'http://wstest.envialia.com:9085/SOAP?service=WebServService'.freeze

          def initialize(tracking_code:)
            self.tracking_code = tracking_code
          end

          def execute
            response = self.class.post(
              API_URL,
              body: body,
              headers: headers,
              debug_output: Deliveries.debug ? Deliveries.logger : nil
            )

            raise Deliveries::ClientError unless response.success?

            parsed_response = Hash.from_xml(response)

            if parsed_response.dig("Envelope", "Body", "WebServService___ConsRecEstadosResponse", "strRecEstados").nil?
              raise Deliveries::APIError.new(
                'No se han encontrado datos para este envío',
                '402'
              )
            else
              parsed_response
            end
          end

          def body
            <<~XML
              <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
                <soapenv:Header>
                  <tns:ROClientIDHeader xmlns:tns="http://tempuri.org/">
                    <tns:ID>#{session_id}</tns:ID>
                  </tns:ROClientIDHeader>
                </soapenv:Header>
                <soapenv:Body>
                  <tns:WebServService___ConsRecEstados xmlns:tns="http://tempuri.org/">
                    <tns:strCodRec>#{tracking_code}</tns:strCodRec>
                  </tns:WebServService___ConsRecEstados>
                </soapenv:Body>
              </soapenv:Envelope>
            XML
          end

          def headers
            { 'Content-Type' => "application/xml; charset='UTF-8'" }
          end
        end
      end
    end
  end
end
