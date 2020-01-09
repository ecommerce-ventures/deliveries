require 'hexapdf'

module Deliveries
  class Labels
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
        generate_merged_pdf
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

    private

    # Join labels in single PDF and return it as String.
    def generate_merged_pdf
      target = HexaPDF::Document.new
      @labels.each do |label|
        pdf = HexaPDF::Document.new(io: StringIO.new(label.raw))
        pdf.pages.each { |page| target.pages << target.import(page) }
      end

      output = StringIO.new
      target.write(output)
      output.string.force_encoding('binary')
    end
  end
end
