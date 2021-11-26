require 'active_support/time'
require 'active_support/core_ext/hash/conversions'
require 'active_support/core_ext/time'

module Deliveries
  module Couriers
    module Envialia
      module Pickups
        class Trace
          class FormatResponse
            attr_accessor :response

            def initialize(response:)
              self.response = response
            end

            STATUS_CODES = {
              'R0' => 'Solicitada',
              'R1' => 'Lectura en delegación',
              'R2' => 'Asignada',
              'R3' => 'Incidencia',
              'R4' => 'Realizada',
              'R5' => 'Pendiente de asignación',
              'R6' => 'Recogida fallida',
              'R7' => 'Finalizada',
              'R8' => 'Anulada',
              'R9' => 'Lectura repartidor'
            }.freeze

            def execute
              body = response.dig('Envelope', 'Body', 'WebServService___ConsRecEstadosResponse', 'strRecEstados')
              parsed_response = Hash.from_xml(body).dig('CONSULTA', 'REC_ESTADOS')

              checkpoints = formatted_checkpoints(parsed_response)

              tracking_info_params = {}
              tracking_info_params[:courier_id] = 'envialia'
              tracking_info_params[:tracking_code] = nil
              tracking_info_params[:status] = checkpoints.last.try(:status)
              tracking_info_params[:checkpoints] = checkpoints

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
              status = STATUS_CODES[shipment_status['V_COD_TIPO_EST']]

              date = shipment_status['D_FEC_HORA_ALTA']

              Deliveries::Checkpoint.new(
                status: status(status),
                location: nil,
                tracked_at: Time.zone.strptime(date, '%m/%d/%Y %H:%M:%S'),
                description: status
              )
            end

            def status(code)
              case code
              when 'Solicitada', 'Lectura en delegación', 'Asignada'
                :registered
              when 'Realizada', 'Recogida Parcial (Múltiples Destinos)'
                :in_transit
              when 'Recogida fallida', 'Datos insuficientes', 'Error al emitir la recogida'
                :delivery_failed
              when 'Anulada', 'Recogida anulada'
                :cancelled
              when 'Finalizada'
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
