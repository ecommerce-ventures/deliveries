require 'httparty'

module Deliveries
  module Couriers
    module Envialia
      module Shipments
        class Trace
          include HTTParty
          include Authentication

          attr_accessor :tracking_code

          def initialize(tracking_code:)
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

            if response.dig("Envelope", "Body", "WebServService___ConsEnvEstadosResponse", "strEnvEstados").nil?
              raise Deliveries::APIError.new(
                'No se han encontrado datos para este envío',
                '402'
              )
            else
              response
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
                  <tns:WebServService___ConsEnvEstados xmlns:tns="http://tempuri.org/">
                    <tns:strCodAgeCargo>#{Deliveries.courier(:envialia).config(:agency_code)}</tns:strCodAgeCargo>
                    <tns:strCodAgeOri>#{Deliveries.courier(:envialia).config(:agency_code)}</tns:strCodAgeOri>
                    <tns:strAlbaran>#{tracking_code}</tns:strAlbaran>
                  </tns:WebServService___ConsEnvEstados>
                </soapenv:Body>
              </soapenv:Envelope>
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
