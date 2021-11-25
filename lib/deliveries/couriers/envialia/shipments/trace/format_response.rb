require 'active_support/time'
require 'active_support/core_ext/time'
require 'active_support/core_ext/hash/conversions'

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
              '0' => 'Documentado',
              '1' => 'En Tránsito',
              '2' => 'En Reparto',
              '3' => 'Incidencia',
              '4' => 'Entregado',
              '5' => 'Devuelto',
              '6' => 'Recanalizado',
              '8' => 'Destruido (P.O.Delegación)',
              '9' => 'Falta definitiva de expedición',
              '10' => 'Pendiente nuevo reparto',
              '11' => 'En CS destino',
              '12' => 'Recogeran en delegacion',
              '14' => 'Entrega Parcial',
              '15' => 'Tránsito 72H.',
              '16' => 'Pendiente de emisión'
            }.freeze

            INCIDENT_CODES = {
              'C01' => 'Estacionado en plataforma',
              'C02' => 'Devuelto por embalaje insuficiente',
              'C03' => 'Mercancía pendiente de revisión',
              'C04' => 'Modificado por Dpto. ATC',
              'C05' => 'Mercancía irregular no permitida',
              'D01' => 'Destinatario ausente / Local cerrado',
              'D04' => 'Rehusado / Rechazado',
              'D05' => 'Dirección incorrecta',
              'D06' => 'No recepcionan / Pte. Fecha de entrega',
              'D07' => 'No paga cobros',
              'D09' => 'No paga CABILDOS/ADUANA',
              'D11' => 'Retorno no preparado',
              'D12' => 'Pendiente recoger destinatario en delegación',
              'D13' => 'Reparto al día siguiente',
              'D14' => 'Robo en destino',
              'D18' => 'No entregar',
              'D19' => 'Entrega reclamada',
              'P01' => 'Pendiente de llegada',
              'P02' => 'Expedición incompleta',
              'P03' => 'Envío mal canalizado',
              'P04' => 'Recibido en mal estado',
              'P05' => 'Falta factura proforma',
              'P06' => 'Demora en llegada de vuelo / barco',
              'P07' => 'Retenido en ADUANA',
              'Z99' => 'Incidencia automática por actuación'
            }.freeze

            def execute
              body = response.dig('Envelope', 'Body', 'WebServService___ConsEnvEstadosResponse', 'strEnvEstados')
              parsed_response = Hash.from_xml(body).dig('CONSULTA', 'ENV_ESTADOS')

              checkpoints = formatted_checkpoints(parsed_response)

              tracking_info_params = {}
              tracking_info_params[:courier_id] = 'envialia'
              tracking_info_params[:tracking_code] = nil
              tracking_info_params[:status] = checkpoints.last.try(:status)
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
              status = STATUS_CODES[shipment_status['V_COD_TIPO_EST']]
              status = INCIDENT_CODES[shipment_status['V_COD_TIPO_EST']] if status.eql?('Incidencia')

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
              when 'Documentado'
                :registered
              when 'En Tránsito', 'En Reparto'
                :in_transit
              when 'Entregado'
                :delivered
              when 'Devuelto'
                :cancelled
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
