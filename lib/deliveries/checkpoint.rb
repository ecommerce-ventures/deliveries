module Deliveries
  class Checkpoint
    attr_accessor :status, :location, :tracked_at, :description

    def initialize(status: nil, location: nil, tracked_at: nil, description: nil)
      self.status = status
      self.location = location
      self.tracked_at = tracked_at
      self.description = description
    end
  end
end
