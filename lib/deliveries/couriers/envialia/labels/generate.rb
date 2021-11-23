require 'httparty'

module Deliveries
  module Couriers
    module Envialia
      module Labels
        class Generate
          include HTTParty
          extend Authentication

          API_URL = 'http://wstest.envialia.com:9085/SOAP?service=WebServService'.freeze

          attr_accessor :tracking_codes

          def initialize(tracking_codes:)
            self.tracking_codes = tracking_codes.respond_to?(:each) ? tracking_codes : [tracking_codes]
          end

          def execute
            decoded_labels = []

            tracking_codes.each do |tracking_code|
              response = self.class.post(
                API_URL,
                body: body(tracking_code),
                headers: headers,
                debug_output: Deliveries.debug ? Deliveries.logger : nil
              )

              raise Deliveries::ClientError unless response.success?

              parsed_response = Hash.from_xml(response)

              labels = parsed_response.dig("Envelope", "Body", "WebServService___ConsEtiquetaEnvio6Response", "strEtiquetas")

              if labels.blank?
                raise Deliveries::APIError.new(
                  "No hay etiqutas disponibles",
                  404
                )
              else
                decoded_labels << Base64.decode64(labels).force_encoding('binary')
              end
            end

            decoded_labels
          end

          private

          def body(tracking_code)
            <<~XML
              <?xml version="1.0" encoding="utf-8"?>
              <soap:Envelope
                xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema">
                <soap:Header>
                  <ROClientIDHeader xmlns="http://tempuri.org/">
                    <ID>#{session_id}</ID>
                  </ROClientIDHeader>
                </soap:Header>
                <soap:Body>
                  <WebServService___ConsEtiquetaEnvio6>
                    <strCodAgeOri>#{Deliveries.courier(:envialia).config(:username)}</strCodAgeOri>
                    <strAlbaran>#{tracking_code}</strAlbaran>
                    <strBulto></strBulto>
                    <boPaginaA4>false</boPaginaA4>
                    <intNumEtiqImpresasA4>0</intNumEtiqImpresasA4>
                    <strFormato>PDF</strFormato>
                  </WebServService___ConsEtiquetaEnvio6>
                </soap:Body>
              </soap:Envelope>
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
