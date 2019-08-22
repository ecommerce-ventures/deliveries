require 'ostruct'

module Deliveries
  class Courier
    class << self
      @config = nil

      def configure
        @config ||= OpenStruct.new
        yield @config
      end

      def configured?
        @config.present?
      end

      # Get configuration value by key.
      #
      # @param key [String|Symbol[]] Dot notation string or array of symbols.
      # @param default [Mixed]
      #
      # @return [Mixed]
      def config(key, default: nil)
        raise 'Courier not configured' unless configured?

        key = key.split('.').map(&:to_sym) if key.is_a? String
        @config.dig(*key) || default
      end

      def test?
        Deliveries.test?
      end

      def live?
        Deliveries.live?
      end

      def shipment_to_home?(country:)
        config("countries.#{country}.shipment", default: []).map(&:to_sym).include? :home
      end

      def shipment_to_collection_point?(country:)
        config("countries.#{country}.shipment", default: []).map(&:to_sym).include? :collection_point
      end

      def pickup_at_home?(country:)
        config("countries.#{country}.pickup", default: []).map(&:to_sym).include? :home
      end

      def pickup_at_collection_point?(country:)
        config("countries.#{country}.pickup", default: []).map(&:to_sym).include? :collection_point
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
