module Deliveries
  class Delivery
    attr_accessor :courier_id, :sender, :receiver, :parcels, :reference_code, :tracking_code

    def initialize(**attributes)
      self.courier_id = attributes[:courier_id]
      self.sender = attributes[:sender]
      self.receiver = attributes[:receiver]
      self.parcels = attributes[:parcels]
      self.reference_code = attributes[:reference_code]
      self.tracking_code = attributes[:tracking_code]
    end
  end
end
