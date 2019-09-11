module Deliveries
  module Couriers
    module CorreosExpress
      module Shipments
        class Trace
          class FormatResponse
            attr_accessor :response

            def initialize(response:)
              self.response = response
            end

            def execute
              tracking_info_params = {}
              tracking_info_params[:courier_id] = 'correos_express'
              tracking_info_params[:tracking_code] = response['NumEnvio']
              tracking_info_params[:status] = status(response["DescEstado"])
              tracking_info_params[:checkpoints] = formatted_checkpoints(response["EstadoEnvios"])

              tracking_info_params
            end

            private

            def formatted_checkpoints(shipment_statuses)
              checkpoints = []
              if shipment_statuses.is_a?(Array)
                shipment_statuses.each do |shipment_status|
                  checkpoints << formatted_checkpoint(shipment_status)
                end
              else
                checkpoints << formatted_checkpoint(shipment_statuses)
              end

              checkpoints
            end

            def formatted_checkpoint(shipment_status)
              Deliveries::Checkpoint.new(
                status: status(shipment_status["DescEstado"]),
                location: nil,
                tracked_at: Time.zone.strptime("#{shipment_status['FechaEstado']} #{shipment_status['HoraEstado']}", '%d%m%Y %H%M%S'),
                description: shipment_status["DescEstado"]
              )
            end

            def status(code)
              case code
              when 'SIN RECEPCION'
                :registered
              when 'EN ARRASTRE', 'DELEGACION DESTINO', 'EN REPARTO', 'TRAMO ORIGEN'
                :in_transit
              when 'ENTREGADO'
                :delivered
              else
                :unknown_status
              end
            end
          end
        end
      end
    end
  end
end
