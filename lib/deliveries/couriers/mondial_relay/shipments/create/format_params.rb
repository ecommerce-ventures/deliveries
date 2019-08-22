module Deliveries
  module Couriers
    class MondialRelay < Deliveries::Courier
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
                'Expe_Langage' => sender.country.to_s.upcase,
                'Expe_Ad1' => I18n.transliterate(sender.name).gsub(/[^0-9A-Z_\-'., \/]/i, '').upcase.truncate(32, omission: ''),
                'Expe_Ad3' => I18n.transliterate(sender.street).gsub(/[^0-9A-Z_\-'., \/]/i, '').upcase.truncate(32, omission: ''),
                'Expe_Ville' => I18n.transliterate(sender.city).gsub(/[^A-Z_\-' ]/i, '').upcase.truncate(25, omission: ''),
                'Expe_CP' => sender.postcode,
                'Expe_Pays' => sender.country.to_s.upcase,
                'Expe_Tel1' => Deliveries.courier('mondial_relay')::Utils.format_phone(sender.phone, sender.country),
                'Expe_Mail' => Deliveries.courier('mondial_relay')::Utils.format_email(sender.email),
                'Dest_Langage' => receiver.country.to_s.upcase,
                'Dest_Ad1' => I18n.transliterate(receiver.name).gsub(/[^0-9A-Z_\-'., \/]/i, '').upcase.truncate(32, omission: ''),
                'Dest_Ad3' => I18n.transliterate(receiver.street).gsub(/[^0-9A-Z_\-'., \/]/i, '').upcase.truncate(32, omission: ''),
                'Dest_Ville' => I18n.transliterate(receiver.city).gsub(/[^A-Z_\-' ]/i, '').upcase.truncate(25, omission: ''),
                'Dest_CP' => receiver.postcode,
                'Dest_Pays' => receiver.country.to_s.upcase,
                'Dest_Tel1' => Deliveries.courier('mondial_relay')::Utils.format_phone(receiver.phone, receiver.country),
                'Dest_Mail' => Deliveries.courier('mondial_relay')::Utils.format_email(receiver.email),
                'NbColis' => parcels,
                'Instructions' => remarks&.truncate(30, omission: '')
              }

              # Receiving in a collection point
              if collection_point.present?
                receive_mode_params = {
                  'ModeCol' => 'REL',
                  'ModeLiv' => '24R',
                  "LIV_Rel_Pays" => receiver.country,
                  "LIV_Rel" => collection_point.point_id,
                  "COL_Rel_Pays" => receiver.country,
                  "COL_Rel" => collection_point.point_id
                }
              else
                receive_mode_params = {
                  'ModeCol' => 'CCC',
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
