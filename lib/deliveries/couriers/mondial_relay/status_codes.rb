module Deliveries
  module Couriers
    class MondialRelay < Deliveries::Courier
      STATUS_CODES = {
        0 => 'Successful operation',
        1 => 'Incorrect merchant',
        2 => 'Merchant number empty',
        3 => 'Incorrect merchant account number',

        5 => 'Incorrect Merchant shipment reference',

        7 => 'Incorrect Consignee reference',
        8 => 'Incorrect password or hash',
        9 => 'Unknown or not unique city',
        10 => 'Incorrect type of collection',
        11 => 'Point Relais collection number incorrect',
        12 => 'Point Relais collection country incorrect',
        13 => 'Incorrect type of delivery',
        14 => 'Incorrect delivery Point Relais number',
        15 => 'Point Relais delivery country incorrect',

        20 => 'Incorrect parcel weight',
        21 => 'Incorrect developped lenght (length + height)',
        22 => 'Incorrect parcel size',

        24 => 'Incorrect shipment number',

        26 => 'Incorrect assembly time',
        27 => 'Incorrect mode of collection or delivery',
        28 => 'Incorrect mode of collection',
        29 => 'Incorrect mode of delivery',
        30 => 'Incorrect address (L1)',
        31 => 'Incorrect address (L2)',

        33 => 'Incorrect address (L3)',
        34 => 'Incorrect address (L4)',

        35 => 'Incorrect city',
        36 => 'Incorrect zip code',
        37 => 'Incorrect country',
        38 => 'Incorrect phone number',
        39 => 'Incorrect e-mail',
        40 => 'Missing parameters',

        42 => 'Incorrect COD value',
        43 => 'Incorrect COD currency',
        44 => 'Incorrect shipment value',
        45 => 'Incorrect shipment value currency',
        46 => 'End of shipments number range reached',
        47 => 'Incorrect number of parcels',
        48 => 'Multi-Parcel not permitted at Point Relais',
        49 => 'Incorrect action',

        60 => 'Incorrect text field (this error code has no impact)',
        61 => 'Incorrect notification request',
        62 => 'Incorrect extra delivery information',
        63 => 'Incorrect insurance',
        64 => 'Incorrect assembly time',
        65 => 'Incorrect appointement',
        66 => 'Incorrect take back',
        67 => 'Incorrect latitude',
        68 => 'Incorrect longitude',
        69 => 'Incorrect merchant code',
        70 => 'Incorrect Point Relais number',
        71 => 'Incorrect Nature de point de vente non valide',
        74 => 'Incorrect language',
        78 => 'Incorrect country of collection',
        79 => 'Incorrect country of delivery',
        80 => 'Tracking code : Recorded parcel',
        81 => 'Tracking code : Parcel in process at Mondial Relay',
        82 => 'Tracking code : Delivered parcel',
        83 => 'Tracking code : Anomaly',
        84 => '(Reserved tracking code)',
        85 => '(Reserved tracking code)',
        86 => '(Reserved tracking code)',
        87 => '(Reserved tracking code)',
        88 => '(Reserved tracking code)',
        89 => '(Reserved tracking code)',
        92 => 'The Point Relais country code and the consignee’s country code are different',
        93 => 'No information given by the sorting plan',
        94 => 'Unknown parcel',
        95 => 'Merchant account not activated',
        97 => 'Incorrect security key',
        98 => 'Generic error (Incorrect parameters)',
        99 => 'Generic error of service system (technical). Contact MR',
      }.freeze

      module StatusCodes
        module_function

        def success?(status)
          status&.zero? || (80..83).cover?(status)
        end

        def tracking_info_success?(status)
          status&.zero? || (80..89).cover?(status)
        end

        def message_for(status)
          STATUS_CODES[status] || 'Unknown status'
        end
      end
    end
  end
end
