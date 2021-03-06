require 'active_support/time'

module Deliveries
  module Couriers
    module CorreosExpress
      module Pickups
        class Trace
          class FormatResponse
            attr_accessor :response

            def initialize(response:)
              self.response = response
            end

            def execute
              tracking_info_params = {}

              checkpoints = formatted_checkpoints([response[:situaciones]].flatten)

              tracking_info_params[:status] = checkpoints.last.try(:status)
              tracking_info_params[:checkpoints] = checkpoints
              tracking_info_params[:courier_id] = 'correos_express'
              tracking_info_params[:tracking_code] = response[:recogida]

              tracking_info_params
            end

            private

            def formatted_checkpoints(shipment_statuses)
              checkpoints = []
              shipment_statuses.each do |shipment_status|
                checkpoints << formatted_checkpoint(shipment_status)
              end
              checkpoints.delete_if { |k, _v| k.status == :unknown_status }
                         .sort_by(&:tracked_at)
            end

            def formatted_checkpoint(shipment_status)
              description = shipment_status[:desc_situacion].to_s
              description += " (#{shipment_status[:desc_motivo]})" if shipment_status[:desc_motivo].present?
              Deliveries::Checkpoint.new(
                status: status_code(shipment_status[:desc_situacion]),
                location: nil,
                tracked_at: Time.zone.strptime((shipment_status[:fec_situacion]).to_s, '%d/%m/%Y %H:%M:%S'),
                description: description
              )
            end

            def status_code(code)
              case code
              when 'PDTE ASIGNAR'
                :registered
              when 'TRANSMITIDA'
                :in_transit
              when 'FALLIDA'
                :delivery_failed
              when 'ANULADA'
                :canceled
              when 'EFECTUADA'
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
