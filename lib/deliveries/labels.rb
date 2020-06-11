module Deliveries
  class Labels
    include LabelUtils

    attr_reader :url

    def initialize(raw: nil, url: nil)
      @raw = raw
      @url = url
      @labels = []
    end

    def raw
      if @raw
        @raw
      elsif @url
        @raw = URI.parse(@url).read.force_encoding('binary')
      elsif !@labels.empty?
        merge_pdfs @labels.map(&:raw)
      end
    end

    def <<(label)
      raise 'Cannot add labels when raw or url are already set' unless @raw.nil? && @url.nil?

      case label
      when Label
        @labels << label
      when %r{\Ahttps?://}
        @labels << Label.new(url: label)
      when String
        @labels << Label.new(raw: label)
      else
        raise "Cannot cast #{label.class.name} to Label"
      end

      self
    end
  end
end
