require 'active_support/time'
require 'byebug'
module Deliveries
  module Couriers
    module Envialia
      module Shipments
        class Trace
          class FormatResponse
            attr_accessor :response

            def initialize(response:)
              self.response = response
            end

            STATUS_CODES = {
              "0" => 'Documentado',
              "1" => 'En Tránsito',
              "2" => 'En Reparto',
              "3" => 'Incidencia',
              "4" => 'Entregado',
              "5" => 'Devuelto',
              "6" => 'Recanalizado',
              "8" => 'Destruido (P.O.Delegación)',
              "9" => 'Falta definitiva de expedición',
              "10" => 'Pendiente nuevo reparto',
              "11" => 'En CS destino',
              "12" => 'Recogeran en delegacion',
              "14" => 'Entrega Parcial',
              "15" => 'Tránsito 72H.',
              "16" => 'Pendiente de emisión',
            }.freeze

            def execute
              body = response.dig("Envelope", "Body", "WebServService___ConsEnvEstadosResponse", "strEnvEstados")
              parsed_response = Hash.from_xml(body).dig("CONSULTA", "ENV_ESTADOS")
              status = STATUS_CODES[parsed_response.dig("V_COD_TIPO_EST")]

              tracking_info_params = {}
              tracking_info_params[:courier_id] = 'envialia'
              tracking_info_params[:tracking_code] = parsed_response.dig("I_ID")
              tracking_info_params[:status] = status(status)
              tracking_info_params[:checkpoints] = formatted_checkpoints(parsed_response)

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
              status = STATUS_CODES[shipment_status.dig("V_COD_TIPO_EST")]

              date = shipment_status.dig("D_FEC_HORA_ALTA")

              Deliveries::Checkpoint.new(
                status: status(status),
                location: nil,
                tracked_at: Time.zone.strptime(date, '%m/%d/%Y %H:%M:%S'),
                description: status
              )
            end

            def status(code)
              case code
              when 'Documentado'
                :registered
              when 'En Tránsito', 'En reparto'
                :in_transit
              when 'Entregado'
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
