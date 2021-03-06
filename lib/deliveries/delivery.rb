module Deliveries
  class Delivery
    ATTRIBUTES = %i[courier_id sender receiver parcels reference_code tracking_code label].freeze
    attr_accessor(*ATTRIBUTES)

    def initialize(**attributes)
      self.courier_id = attributes[:courier_id]
      self.sender = attributes[:sender]
      self.receiver = attributes[:receiver]
      self.parcels = attributes[:parcels]
      self.reference_code = attributes[:reference_code]
      self.tracking_code = attributes[:tracking_code]
      self.label = attributes[:label]
    end

    def attributes
      ATTRIBUTES.map { |attr| { attr => send(attr) } }.inject(&:merge)
    end
  end
end
