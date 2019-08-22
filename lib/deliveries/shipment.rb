module Deliveries
  class Shipment < Delivery
    attr_accessor :shipment_date

    def initialize(**attributes)
      super(attributes)

      self.shipment_date = attributes[:shipment_date]
    end
  end
end
