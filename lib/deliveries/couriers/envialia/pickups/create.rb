require 'httparty'

module Deliveries
  module Couriers
    module Envialia
      module Pickups
        class Create
          include HTTParty
          include Authentication

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
            response = self.class.post(
              api_endpoint,
              body: body,
              headers: headers,
              debug_output: Deliveries.debug ? Deliveries.logger : nil
            )

            raise Deliveries::ClientError unless response.success?

            pickup_number = response.dig('Envelope', 'Body', 'WebServService___GrabaRecogida3Response', 'strCodOut')

            if pickup_number
              Deliveries::Pickup.new(
                courier_id: 'envialia',
                sender: sender,
                receiver: receiver,
                parcels: parcels,
                reference_code: reference_code,
                tracking_code: pickup_number,
                pickup_date: pickup_date
              )
            else
              exception = response.dig('Envelope', 'Body', 'Fault')

              if exception['faultcode'].eql?('Exception')
                exception_code, exception_str = exception['faultstring'].split(':')
              else
                exception_code = 400
                exception_str = exception['faultstring']
              end

              raise Deliveries::APIError.new(
                exception_str.strip,
                exception_code.to_i
              )
            end
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
                  <strCodAgeCargo>#{Deliveries.courier(:envialia).config(:agency_code)}</strCodAgeCargo>
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
                  <strCodTipoServ>72</strCodTipoServ>
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
            { 'Content-Type' => 'application/json;charset=UTF-8', 'Accept' => 'application/json' }
          end

          def api_endpoint
            if Envialia.live?
              Envialia::ENVIALIA_ENDPOINT_LIVE
            else
              Envialia::ENVIALIA_ENDPOINT_TEST
            end
          end
        end
      end
    end
  end
end
