module Deliveries
  class Pickup < Delivery
    attr_accessor :pickup_date

    def initialize(delivery: nil, **attributes)
      if delivery.is_a? Deliveries::Delivery
        super(**delivery.attributes)
      else
        super(**attributes)
      end

      self.pickup_date = attributes[:pickup_date]
    end
  end
end
