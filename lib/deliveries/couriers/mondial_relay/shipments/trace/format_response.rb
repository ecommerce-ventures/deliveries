module Deliveries
  module Couriers
    class MondialRelay < Deliveries::Courier
      module Shipments
        class Trace
          class FormatResponse
            attr_accessor :response

            def initialize(response:)
              self.response = response
            end

            def execute
              statuses = response[:tracing][:ret_wsi2_sub_tracing_colis_detaille].delete_if{ |key, _value| key[:libelle].blank? }

              tracking_info_params = {}
              tracking_info_params[:courier_id] = 'mondial_relay'
              tracking_info_params[:status] = shipment_status(response[:stat].to_i, last_status(statuses))
              tracking_info_params[:checkpoints] = formatted_checkpoints(statuses)

              tracking_info_params
            end

            private

            def last_status(statuses)
              statuses.map{ |v| v[:libelle] }
                      .compact
                      .last
            end

            def formatted_checkpoints(statuses)
              checkpoints = []
              statuses.each do |status|
                checkpoints << formatted_checkpoint(status)
              end

              checkpoints
            end

            def formatted_checkpoint(status)
              Deliveries::Checkpoint.new(
                status: checkpoint_status(status[:libelle]),
                location: status[:emplacement],
                tracked_at: Time.zone.strptime("#{status[:date]} #{status[:heure]}", '%d/%m/%y %H:%M'),
                description: status[:libelle]
              )
            end

            def shipment_status(stat, last_checkpoint_status)
              if stat == 80
                :registered
              elsif stat == 82
                :delivered
              elsif stat == 81
                if last_checkpoint_status == 'Disponible en el Punto Pack' ||
                   last_checkpoint_status == 'DISPONIBLE AU POINT RELAIS'
                :in_collection_point
                else
                  :in_transit
                end
              else
                :unknown_status
              end
            end

            def checkpoint_status(message)
              case message
              when 'Disponible en el Punto Pack', 'Recepcionado en el Punto Pack',
                   'DISPONIBLE AU POINT RELAIS', 'PRISE EN CHARGE POINT RELAIS'
                :in_collection_point
              when 'Recogido en agencia Punto Pack',
                   'RÉCEPTION DES DONNÉES'
                :registered
              when 'Recogido en el hub', 'En reparto',
                   'PRISE EN CHARGE EN AGENCE', 'COLIS REMIS AU LIVREUR'
                :in_transit
              when 'Paquete entregado al Destinata', 'Liquidado en Ensena',
                   'COLIS LIVRÉ'
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
