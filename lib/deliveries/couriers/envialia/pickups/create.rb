require 'httparty'

module Deliveries
  module Couriers
    module Envialia
      module Pickups
        class Create
          include HTTParty
          extend Authentication

          API_URL = 'http://wstest.envialia.com:9085/SOAP?service=WebServService'.freeze

          attr_accessor :sender, :receiver, :parcels,
                        :reference_code, :pickup_date, :remarks, :tracking_code

          def initialize(sender:, receiver:, parcels:,
                         reference_code:, pickup_date:, remarks:, tracking_code:)

            self.sender = sender
            self.receiver = receiver
            self.parcels = parcels
            self.reference_code = reference_code
            self.pickup_date = pickup_date
            self.remarks = remarks
            self.tracking_code = tracking_code
          end

          def execute
            response = HTTParty.post(
              API_URL,
              body: body,
              headers: headers
            )

            parsed_response = Hash.from_xml(response)

            pickup_number = parsed_response.dig("Envelope", "Body", "WebServService___GrabaRecogida3Response", "strCodOut")

            Deliveries::Pickup.new(
              courier_id: 'envialia',
              sender: sender,
              receiver: receiver,
              parcels: parcels,
              reference_code: reference_code,
              tracking_code: pickup_number,
              pickup_date: pickup_date
            )
          end

          private

          def body
            <<~XML
            <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
              <soap:Header>
              <ROClientIDHeader xmlns="http://tempuri.org/">
                <ID>#{session_id}</ID>
              </ROClientIDHeader>
              </soap:Header>
              <soap:Body>
              <WebServService___GrabaRecogida3 xmlns="http://tempuri.org/">
                <strCod></strCod>
                <strAlbaran>#{tracking_code}</strAlbaran>
                <strCodAgeCargo>#{Deliveries.courier(:envialia).config(:username)}</strCodAgeCargo>
                <strCodAgeOri></strCodAgeOri>
                <dtFecRec>#{pickup_date.strftime('%Y/%m/%d')}</dtFecRec>
                <strNomOri>#{sender.name}</strNomOri>
                <strDirOri>#{sender.street}</strDirOri>
                <strCPOri>#{sender.postcode}</strCPOri>
                <strTlfOri>#{sender.phone}</strTlfOri>
                <strNomDes>#{receiver.name}</strNomDes>
                <strDirDes>#{receiver.street}</strDirDes>
                <strCPDes>#{receiver.postcode}</strCPDes>
                <strTlfDes>#{receiver.phone}</strTlfDes>
                <intBul>#{parcels}</intBul>
                <dPesoOri>0</dPesoOri>
                <dAltoOri>0</dAltoOri>
                <dAnchoOri>0</dAnchoOri>
                <dLargoOri>0</dLargoOri>
                <dReembolso>0</dReembolso>
                <dValor>0</dValor>
                <dAnticipo>0</dAnticipo>
                <dCobCli>0</dCobCli>
                <strObs>#{remarks}</strObs>
                <boSabado>false</boSabado>
                <boRetorno>false</boRetorno>
                <boGestOri>false</boGestOri>
                <boGestDes>false</boGestDes>
                <boAnulado>false</boAnulado>
                <boAcuse>false</boAcuse>
                <strRef>#{reference_code}</strRef>
                <dBaseImp>0</dBaseImp>
                <dImpuesto>0</dImpuesto>
                <boPorteDebCli>false</boPorteDebCli>
                <strDesDirEmails>#{receiver.email}</strDesDirEmails>
                <boCampo5>false</boCampo5>
                <boPagoDUAImp>false</boPagoDUAImp>
                <boPagoImpDes>false</boPagoImpDes>
              </WebServService___GrabaRecogida3>
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
