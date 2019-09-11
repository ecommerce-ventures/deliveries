module Deliveries
  module Couriers
    module CorreosExpress
      module Shipments
        class Create
          include HTTParty
          persistent_connection_adapter

          attr_accessor :sender, :receiver, :collection_point, :parcels,
                        :reference_code,:shipment_date, :remarks

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
            if response.success?
              parsed_response = JSON.parse(response.body, symbolize_names: true)
              if parsed_response.dig(:codigoRetorno) == 0 && parsed_response.dig(:datosResultado).present?
                expedition_num = parsed_response.dig(:datosResultado)
                delivery = Deliveries::Delivery.new(
                  courier_id: 'correos_express',
                  sender: sender,
                  receiver: receiver,
                  parcels: parcels,
                  reference_code: reference_code,
                  tracking_code: expedition_num
                )

                delivery
              else
                raise Deliveries::APIError.new(
                  parsed_response.dig(:mensajeRetorno),
                  parsed_response.dig(:codigoRetorno)
                )
              end
            else
              raise Deliveries::ClientError
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
            { "Content-Type" => "application/json; charset='UTF-8'" }
          end
        end
      end
    end
  end
end
