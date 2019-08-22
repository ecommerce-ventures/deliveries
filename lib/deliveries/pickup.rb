module Deliveries
  class Pickup < Delivery
    attr_accessor :pickup_date

    def initialize(**attributes)
      super(attributes)

      self.pickup_date = attributes[:pickup_date]
    end
  end
end
