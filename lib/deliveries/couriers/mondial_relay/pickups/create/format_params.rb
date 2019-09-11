module Deliveries
  module Couriers
    module MondialRelay
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
              params = {
                'Enseigne' => Deliveries::Couriers::MondialRelay.config(:mondial_relay_merchant),
                'ModeCol' => 'REL',
                'ModeLiv' => 'LCC',
                'COL_Rel_Pays' => 'XX',
                'COL_Rel' => 'AUTO',
                'NDossier' => reference_code,
                'Expe_Langage' => sender.country,
                'Expe_Ad1' => sender.name,
                'Expe_Ad3' => sender.street,
                'Expe_Ville' => sender.city,
                'Expe_CP' => sender.postcode,
                'Expe_Pays' => sender.country,
                'Expe_Tel1' => sender.phone,
                'Expe_Mail' => sender.email,
                'Dest_Langage' => receiver.country,
                'Dest_Ad1' => receiver.name,
                'Dest_Ad3' => receiver.street,
                'Dest_Ville' => receiver.city,
                'Dest_CP' => receiver.postcode,
                'Dest_Pays' => receiver.country,
                'Dest_Tel1' => receiver.phone,
                'Dest_Mail' => receiver.email,
                'NbColis' => parcels,
                'Instructions' => I18n.transliterate(remarks.to_s).gsub(/[^0-9A-Z_\-'., \/]/i, '').upcase.truncate(30, omission: '')
              }

              defaults = Shipments::Create::Defaults::PARAMS

              defaults.merge(params)
            end
          end
        end
      end
    end
  end
end
