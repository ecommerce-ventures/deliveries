require 'httparty'

module Deliveries
  module Couriers
    module Envialia
      module Shipments
        class Create
          include HTTParty

          API_URL = 'http://wstest.envialia.com:9085/SOAP?service=WebServService'.freeze

          attr_accessor :sender, :receiver, :collection_point, :parcels,
                        :reference_code, :shipment_date, :remarks

          def initialize(sender:, receiver:, collection_point:, parcels:,
                         reference_code:, shipment_date:, remarks:)
            self.sender = sender
            self.receiver = receiver
            self.collection_point = collection_point
            self.parcels = parcels
            self.reference_code = reference_code
            self.shipment_date = shipment_date
            self.remarks = remarks
          end

          def execute
            response = HTTParty.post(
              API_URL,
              body: body,
              headers: headers
            )

            parsed_response = Hash.from_xml(response)

            tracking_code = parsed_response.dig("Envelope", "Body", "WebServService___GrabaEnvio8Response", "strAlbaranOut")

            Deliveries::Shipment.new(
              courier_id: 'envialia',
              sender: sender,
              receiver: receiver,
              parcels: parcels,
              reference_code: reference_code,
              tracking_code: tracking_code,
              shipment_date: shipment_date,
              label: nil
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
                  <WebServService___GrabaEnvio8 xmlns="http://tempuri.org/">
                    <strCodAgeCargo>#{Deliveries.courier(:envialia).config(:username)}</strCodAgeCargo>
                    <strCodAgeOri>#{Deliveries.courier(:envialia).config(:username)}</strCodAgeOri>
                    <dtFecha>#{shipment_date.strftime('%Y/%m/%d')}</dtFecha>
                    <strCodTipoServ>72</strCodTipoServ>
                    <strCodCli>1004</strCodCli>
                    <strNomOri>#{sender.name}</strNomOri>
                    <strDirOri>#{sender.street}</strDirOri>
                    <strCPOri>#{sender.postcode}</strCPOri>
                    <strTlfOri>#{sender.phone}</strTlfOri>
                    <strNomDes>#{receiver.name}</strNomDes>
                    <strDirDes>#{receiver.street}</strDirDes>
                    <strCPDes>#{receiver.postcode}</strCPDes>
                    <strTlfDes>#{receiver.phone}</strTlfDes>
                    <intDoc>0</intDoc>
                    <intPaq>#{parcels}</intPaq>
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
                    <boInsert>true</boInsert>
                    <boCampo5>false</boCampo5>
                    <boPagoDUAImp>false</boPagoDUAImp>
                    <boPagoImpDes>false</boPagoImpDes>
                  </WebServService___GrabaEnvio8>
                </soap:Body>
              </soap:Envelope>
            XML
          end

          def headers
            { 'Content-Type' => "application/xml; charset='UTF-8'" }
          end

          def session_id
            Deliveries.courier(:envialia).login
          end
        end
      end
    end
  end
end
