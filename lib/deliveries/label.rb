module Deliveries
  class Label
    attr_accessor :raw, :url

    def initialize(**attributes)
      self.raw = attributes[:raw]
      self.url = attributes[:url]
    end
  end
end
