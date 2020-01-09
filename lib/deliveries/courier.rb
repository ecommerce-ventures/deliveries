require 'ostruct'

module Deliveries
  module Courier
    @config = nil

    def configure
      @config ||= ancestors.first::Config.new
      yield @config
    end

    def configured?
      @config.present?
    end

    # Get configuration value by key.
    #
    # @param key [String, Symbol[]] Dot notation string or array of symbols.
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

    def get_collection_point(global_point_id:)
      raise NotImplementedError
    end

    def get_collection_points(country:, postcode:)
      raise NotImplementedError
    end

    def create_shipment(sender:, receiver:, collection_point:, parcels:, reference_code:, shipment_date: nil, remarks: nil, language: nil)
      raise NotImplementedError
    end

    def create_pickup(sender:, receiver:, parcels:, reference_code:, pickup_date: nil, remarks: nil, language: nil)
      raise NotImplementedError
    end

    def get_label(tracking_code:, language: nil)
      raise NotImplementedError
    end

    def get_labels(tracking_codes:, language: nil)
      raise NotImplementedError
    end

    def shipment_info(tracking_code:, language: nil)
      raise NotImplementedError
    end

    def pickup_info(tracking_code:, language: nil)
      raise NotImplementedError
    end
  end
end
