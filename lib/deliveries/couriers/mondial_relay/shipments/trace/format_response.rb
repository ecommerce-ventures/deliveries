require 'active_support/time'

module Deliveries
  module Couriers
    module MondialRelay
      module Shipments
        class Trace
          class FormatResponse
            attr_accessor :response

            def initialize(response:)
              self.response = response
            end

            def execute
              statuses = response[:tracing][:ret_wsi2_sub_tracing_colis_detaille].delete_if do |key, _value|
                key[:libelle].blank?
              end

              tracking_info_params = {}
              tracking_info_params[:courier_id] = 'mondial_relay'
              tracking_info_params[:status] = shipment_status(response[:stat].to_i, last_status(statuses))
              tracking_info_params[:checkpoints] = formatted_checkpoints(statuses)

              tracking_info_params
            end

            private

            def last_status(statuses)
              statuses.map{ |s| s[:libelle] }
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
              case stat
              when 80
                :registered
              when 82
                :delivered
              when 81
                if ['Disponible en el Punto Pack', 'DISPONIBLE AU POINT RELAIS'].include?(last_checkpoint_status)
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
