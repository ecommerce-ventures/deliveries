module Deliveries
  class Label
    attr_reader :url

    def initialize(raw: nil, url: nil)
      raise ArgumentError, 'Both raw and url cannot be nil' if raw.nil? && url.nil?

      @raw = raw
      @url = url
    end

    def raw
      if @raw
        @raw
      elsif @url
        @raw = URI.parse(@url).read.force_encoding('binary')
      end
    end
  end
end
