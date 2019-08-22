# COLLECTION MODES:
# CCC: Merchant collection
# CDR: Home collection standard shipments
# CDS: Home collection heavy shipments
# REL: Point relais collection

# DELIVERY MODES:
# 24R: Point relais delivery
# 24L: POint relais XL delivery
# 24X: Point relais XXL delivery
# DRI: Colis drive delivery
# LD1: Home delivery(1 delivery man)
# LDS: Home delivery(2 delivery men)
# HOM: Home delivery < 30kg
# HOC: Home delivery (specific for Spain)
# LCC: Reverse

module Deliveries
  module Couriers
    class MondialRelay
      module Shipments
        class Create
          module Defaults
            COLLECTION_MODES = {
              home_collection_standard: 'CDR',
              point_relais_collection: 'REL'
            }.freeze

            DELIVERY_MODES = {
              home_delivery_standard: 'LD1',
              point_relais_delivery: '24R'
            }.freeze

            PARAMS = {
              'Enseigne' => '',
              'ModeCol' => 'CCC', # Collection mode
              'ModeLiv' => '', # Delivery mode
              'NDossier' => '', # Reference code

              'NClient' => '', # sender reference
              'Expe_Langage' => '',
              'Expe_Ad1' => '',
              'Expe_Ad2' => '',
              'Expe_Ad3' => '',
              'Expe_Ad4' => '',
              'Expe_Ville' => '',
              'Expe_CP' => '',
              'Expe_Pays' => '',
              'Expe_Tel1' => '',
              'Expe_Tel2' => '',
              'Expe_Mail' => '',

              'Dest_Langage' => '',
              'Dest_Ad1' => '',
              'Dest_Ad2' => '',
              'Dest_Ad3' => '',
              'Dest_Ad4' => '',
              'Dest_Ville' => '',
              'Dest_CP' => '',
              'Dest_Pays' => '',
              'Dest_Tel1' => '',
              'Dest_Tel2' => '',
              'Dest_Mail' => '',

              'Poids' => '1000', # weight in grams
              'Longueur' => '', # length
              'Taille' => '', # size
              'NbColis' => "1", # Number of parcels

              # TODO: COD shipment value in cents?
              'CRT_Valeur' => '0',
              'CRT_Devise' => '',
              'Exp_Valeur' => '', # Price
              'Exp_Devise' => '', # Currency

              # Collection point info
              'COL_Rel_Pays' => '',
              'COL_Rel' => '',

              # Delivery point info
              'LIV_Rel_Pays' => '',
              'LIV_Rel' => '',

              'TAvisage' => '', # notify
              'TReprise' => '',
              'Montage' => '', # assembly time
              'TRDV' => '', # request for delivery appointment
              'Assurance' => '',
              'Instructions' => ''
            }.freeze
          end
        end
      end
    end
  end
end
