module Deliveries
  class Shipment < Delivery
    attr_accessor :shipment_date

    def initialize(delivery: nil, **attributes)
      if delivery.is_a? Deliveries::Delivery
        super(**delivery.attributes)
      else
        super(**attributes)
      end

      self.shipment_date = attributes[:shipment_date]
    end
  end
end
