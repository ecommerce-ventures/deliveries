module Deliveries
  module Couriers
    module CorreosExpress
      module Shipments
        class Create
          include HTTParty

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
            auth = {
              username: CorreosExpress.config(:username),
              password: CorreosExpress.config(:password)
            }

            params = FormatParams.new(
              sender: sender.courierize(:correos_express),
              receiver: receiver.courierize(:correos_express),
              collection_point: collection_point,
              parcels: parcels,
              reference_code: reference_code,
              shipment_date: shipment_date,
              remarks: remarks
            ).execute

            response = self.class.post(
              api_endpoint,
              basic_auth: auth,
              body: params,
              headers: headers,
              debug_output: Deliveries.debug ? Deliveries.logger : nil
            )
            raise Deliveries::ClientError unless response.success?

            parsed_response = JSON.parse(response.body, symbolize_names: true)
            if parsed_response[:codigoRetorno].zero? && parsed_response.key?(:datosResultado)
              tracking_code = parsed_response[:datosResultado]
              decoded_label = decode_label(parsed_response.dig(:etiqueta, 0, :etiqueta1))
              label = Label.new(raw: decoded_label) if decoded_label

              Deliveries::Shipment.new(
                courier_id: 'correos_express',
                sender: sender,
                receiver: receiver,
                parcels: parcels,
                reference_code: reference_code,
                tracking_code: tracking_code,
                shipment_date: shipment_date,
                label: label
              )
            else
              raise Deliveries::APIError.new(
                parsed_response[:mensajeRetorno],
                parsed_response[:codigoRetorno]
              )
            end
          end

          private

          def api_endpoint
            if CorreosExpress.live?
              CorreosExpress::SHIPMENTS_ENDPOINT_LIVE
            else
              CorreosExpress::SHIPMENTS_ENDPOINT_TEST
            end
          end

          def headers
            { 'Content-Type' => "application/json; charset='UTF-8'" }
          end

          def decode_label(encoded_label)
            return nil if encoded_label.blank?

            decoded_label = Base64.decode64(Base64.decode64(encoded_label)).force_encoding('binary')

            # Check pdf file signature
            return nil unless decoded_label[0..4].unpack1('H*').hex == 0x255044462d

            decoded_label
          end
        end
      end
    end
  end
end
