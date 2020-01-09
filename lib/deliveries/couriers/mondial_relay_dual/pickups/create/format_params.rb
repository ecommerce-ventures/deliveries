module Deliveries
  module Couriers
    module MondialRelayDual
      module Pickups
        class Create
          class FormatParams < Shipments::Create::FormatParams
            def initialize(sender:, receiver:, parcels:, reference_code:, remarks:, language:)
              super(
                sender: sender,
                receiver: receiver,
                parcels: parcels,
                reference_code: reference_code,
                remarks: remarks,
                language: language,
                collection_point: nil
              )
            end

            private

            def delivery_mode
              {
                mode: 'LCC',
                location: ''
              }
            end

            def collection_mode
              {
                mode: 'REL',
                location: ''
              }
            end
          end
        end
      end
    end
  end
end
  