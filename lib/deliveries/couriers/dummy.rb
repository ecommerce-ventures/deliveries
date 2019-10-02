module Deliveries
  module Couriers
    module Dummy
      extend Courier

      module_function

      def get_collection_point(global_point_id:)
        point = CollectionPoint.parse_global_point_id global_point_id: global_point_id
        CollectionPoint.new name: 'Dumy',
                            email: 'dummy@dummy.com',
                            phone: '555 555 555',
                            country: point.country.to_sym,
                            state: 'Bizkaia',
                            city: 'Erandio',
                            street: 'Axpe',
                            postcode: point.postcode,
                            courier_id: 'dumy',
                            point_id: point.point_id,
                            latitude: 43.312132,
                            longitude: -2.979586,
                            timetable: {
                              0 => [],
                              1 => [OpenStruct.new(open: '8:00', close: '14:00'), OpenStruct.new(open: '16:00', close: '20:00')],
                              2 => [OpenStruct.new(open: '8:00', close: '14:00'), OpenStruct.new(open: '16:00', close: '20:00')],
                              3 => [OpenStruct.new(open: '8:00', close: '14:00'), OpenStruct.new(open: '16:00', close: '20:00')],
                              4 => [OpenStruct.new(open: '8:00', close: '14:00'), OpenStruct.new(open: '16:00', close: '20:00')],
                              5 => [OpenStruct.new(open: '8:00', close: '15:00')],
                              6 => []
                            },
                            url_map: nil,
                            url_photo: nil
      end

      def get_collection_points(country:, postcode:)
        [
          get_collection_point(global_point_id: "dummy~#{country}~#{postcode}~1"),
          get_collection_point(global_point_id: "dummy~#{country}~#{postcode}~2")
        ]
      end

      def shipment_info(tracking_code:, language: nil)
        TrackingInfo.new courier_id: 'dummy',
                         tracking_code: tracking_code,
                         status: :in_transit,
                         checkpoints: [
                           Checkpoint.new(status: :registered, location: 'Source city', tracked_at: 1.week.ago, description: 'Parcel taken'),
                           Checkpoint.new(status: :in_transit, location: 'Halfway city', tracked_at: 1.day.ago, description: 'There is some delay')
                         ],
                         url: 'https://google.com'
      end

      def pickup_info(tracking_code:, language: nil)
        TrackingInfo.new courier_id: 'dummy',
                         tracking_code: tracking_code,
                         status: :in_transit,
                         checkpoints: [
                           Checkpoint.new(status: :registered, location: 'Source city', tracked_at: 1.week.ago, description: 'Parcel taken'),
                           Checkpoint.new(status: :in_transit, location: 'Halfway city', tracked_at: 1.day.ago, description: 'There is some delay')
                         ],
                         url: 'https://google.com'
      end

      def create_shipment(sender:, receiver:, collection_point:, parcels:, reference_code:, shipment_date: nil, remarks: nil)
        Shipment.new courier_id: 'dummy',
                     sender: sender,
                     receiver: receiver,
                     parcels: parcels,
                     reference_code: reference_code,
                     tracking_code: reference_code,
                     shipment_date: shipment_date
      end

      def create_pickup(sender:, receiver:, parcels:, reference_code:, pickup_date: nil, remarks: nil)
        Pickup.new courier_id: 'dummy',
                   sender: sender,
                   receiver: receiver,
                   parcels: parcels,
                   reference_code: reference_code,
                   tracking_code: reference_code,
                   pickup_date: pickup_date
      end

      def get_label(tracking_code:, language:)
        pdf = <<~PDF
          %PDF-1.0
          1 0 obj<</Pages 2 0 R>>endobj 2 0 obj<</Kids[3 0 R]/Count 1>>endobj 3 0 obj<</MediaBox[0 0 3 3]>>endobj
          trailer<</Root 1 0 R>>
        PDF
        Deliveries::Label.new(
          raw: pdf,
          url: nil
        )
      end

      def get_labels(tracking_codes:, language:)
        get_label tracking_code: tracking_codes, language: language
      end
    end
  end
end
