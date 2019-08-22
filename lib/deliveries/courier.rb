require 'ostruct'

module Deliveries
  class Courier
    class << self
      def configure
        @@config ||= OpenStruct.new
        yield @@config
      end

      def configured?
        class_variable_defined? :@@config
      end

      def test?
        Deliveries.test?
      end

      def live?
        Deliveries.live?
      end

      def shipment_to_home?(country:)
        raise NotImplementedError
      end

      def shipment_to_collection_point?(country:)
        raise NotImplementedError
      end

      def pickup_at_home?(country:)
        raise NotImplementedError
      end

      def pickup_at_collection_point?(country:)
        raise NotImplementedError
      end

      def get_collection_point(global_point_id:)
        raise NotImplementedError
      end

      def get_collection_points(country:, postcode:)
        raise NotImplementedError
      end

      def create_shipment(sender:, receiver:, collection_point:, parcels:, reference_code:, shipment_date: nil, remarks: nil)
        raise NotImplementedError
      end

      def create_pickup(sender:, receiver:, parcels:, reference_code:, pickup_date: nil, remarks: nil)
        raise NotImplementedError
      end

      def get_label(tracking_code:, language:)
        raise NotImplementedError
      end

      def get_labels(tracking_codes:, language:)
        raise NotImplementedError
      end

      def shipment_info(tracking_code:, language:)
        raise NotImplementedError
      end

      def pickup_info(tracking_code:, language:)
        raise NotImplementedError
      end
    end
  end
end
