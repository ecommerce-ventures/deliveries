require 'httparty'
require 'nokogiri'

module Deliveries
  module Couriers
    module Envialia
      module Pickups
        class Details
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

            pickup_data = response.dig('Envelope', 'Body', 'WebServService___ConsRecogidaResponse', 'strRecogida')

            if pickup_data
              Nokogiri::XML(pickup_data).at_xpath('//RECOGIDAS')&.attributes&.transform_values(&:value)
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
              <soap:Envelope
                xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema">
                <soap:Header>
                  <ROClientIDHeader
                    xmlns="http://tempuri.org/">
                    <ID>#{session_id}</ID>
                  </ROClientIDHeader>
                </soap:Header>
                <soap:Body>
                  <WebServService___ConsRecogida>
                    <strCod>#{tracking_code}</strCod>
                  </WebServService___ConsRecogida>
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
