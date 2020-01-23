module Deliveries
  module Couriers
    module MondialRelay
      module Shipments
        class Create
          class FormatParams
            attr_accessor :sender, :receiver, :parcels, :reference_code, :collection_point, :remarks

            def initialize(sender:, receiver:, parcels:, reference_code:, collection_point:, remarks:)
              self.sender = sender
              self.receiver = receiver
              self.parcels = parcels
              self.reference_code = reference_code
              self.collection_point = collection_point
              self.remarks = remarks
            end

            def execute
              params = {
                'Enseigne' => Deliveries::Couriers::MondialRelay.config(:mondial_relay_merchant),
                'NDossier' => reference_code,
                'Expe_Langage' => sender.country,
                'Expe_Ad1' => sender.name,
                'Expe_Ad3' => sender.street,
                'Expe_Ville' => sender.city,
                'Expe_CP' => sender.postcode,
                'Expe_Pays' => sender.country,
                'Expe_Tel1' => sender.phone,
                'Expe_Mail' => sender.email,
                'Dest_Langage' => receiver.country.to_s.upcase,
                'Dest_Ad1' => receiver.name,
                'Dest_Ad3' => receiver.street,
                'Dest_Ville' => receiver.city,
                'Dest_CP' => receiver.postcode,
                'Dest_Pays' => receiver.country.to_s.upcase,
                'Dest_Tel1' => receiver.phone,
                'Dest_Mail' => receiver.email,
                'NbColis' => parcels,
                'Instructions' => I18n.transliterate(remarks.to_s).gsub(/[^0-9A-Z_\-'., \/]/i, '').upcase.truncate(30, omission: '')
              }

              # Receiving in a collection point
              if collection_point.present?
                receive_mode_params = {
                  'ModeLiv' => '24R',
                  "LIV_Rel_Pays" => receiver.country,
                  "LIV_Rel" => collection_point.point_id,
                  "COL_Rel_Pays" => receiver.country,
                  "COL_Rel" => collection_point.point_id
                }
              else
                receive_mode_params = {
                  'ModeLiv' => 'HOM'
                }
              end

              defaults = Defaults::PARAMS

              defaults.merge(params).merge(receive_mode_params)
            end
          end
        end
      end
    end
  end
end
