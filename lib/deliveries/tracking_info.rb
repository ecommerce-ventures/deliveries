module Deliveries
  class TrackingInfo
    attr_accessor :courier_id, :tracking_code, :status, :checkpoints, :url

    def initialize(courier_id:, tracking_code:, status: nil, checkpoints: nil, url: nil)
      self.courier_id = courier_id
      self.tracking_code = tracking_code
      self.status = status
      self.checkpoints = checkpoints
      self.url = url
    end

    def registered?
      status == :registered
    end

    def in_transit?
      status == :in_transit
    end

    def in_collection_point?
      status == :in_collection_point
    end

    def delivered?
      status == :delivered
    end
  end
end
