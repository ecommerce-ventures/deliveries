module Deliveries
    module Couriers
      module MondialRelayDual
        module Pickups
          class Create
            class FormatParams
              attr_accessor :sender, :receiver, :parcels, :reference_code, :pickup_date, :remarks

              def initialize(sender:, receiver:, parcels:, reference_code:, pickup_date:, remarks:)
                self.sender = sender
                self.receiver = receiver
                self.parcels = parcels
                self.reference_code = reference_code
                self.pickup_date = pickup_date
                self.remarks = remarks
              end
  
              def execute
                params = Deliveries::Couriers::MondialRelay::Pickups::Create::FormatParams.new(
                  sender: sender,
                  receiver: receiver,
                  parcels: parcels,
                  reference_code: reference_code,
                  pickup_date: pickup_date,
                  remarks: remarks
                ).execute

                # The collection mode must be set to REL (point relais collection)
                # and the collection point id is not needed unlike when using single carrier api.
                params['ModeCol'] = 'REL'

                params
              end
            end
          end
        end
      end
    end
  end
  