module Deliveries
  module Couriers
    class Spring < Deliveries::Courier
      module Shipments
        class Trace
          class FormatResponse
            attr_accessor :response

            def initialize(response:)
              self.response = response
            end

            def execute
              checkpoints = response[:Events].sort_by{ |event| event[:DateTime] }

              tracking_info_params = {}
              tracking_info_params[:courier_id] = Deliveries::Couriers::Spring::ID
              tracking_info_params[:tracking_code] = response[:TrackingNumber]
              tracking_info_params[:status] = status(checkpoints.last[:Code])
              tracking_info_params[:checkpoints] = formatted_checkpoints(checkpoints)

              tracking_info_params
            end

            private

            def formatted_checkpoints(shipment_statuses)
              shipment_statuses.map do |shipment_status|
                formatted_checkpoint(shipment_status)
              end
            end

            def formatted_checkpoint(shipment_status)
              Deliveries::Checkpoint.new(
                status: status(shipment_status[:Code]),
                location: shipment_status[:Country],
                tracked_at: Time.zone.strptime(shipment_status[:DateTime], '%Y-%m-%d %H:%M:%S'),
                description: shipment_status[:CarrierDescription]
              )
            end

            def status(code)
              # Spring Tracking Event Codes List
              # ---
              #   0 - PARCEL CREATED
              #  20 - ACCEPTED
              #  21 - IN TRANSIT
              #  31 - DELIVERY EXCEPTION
              #  40 - IN CUSTOMS
              #  41 - CUSTOMS EXCEPTION
              #  91 - DELIVERY ATTEMPTED
              #  92 - DELIVERY AWAITING COLLECTION
              #  93 - DELIVERY SCHEDULED
              # 100 - DELIVERED
              # 111 - LOST OR DESTROYED
              # 124 - RETURN IN TRANSIT
              # 125 - RETURN RECEIVED

              case code
              when 0, 20
                :registered
              when 21, 40, 41, 91, 93
                :in_transit
              when 92
                :in_collection_point
              when 100
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
