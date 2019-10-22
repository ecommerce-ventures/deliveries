require 'hexapdf'

module Deliveries
  class Label
    attr_accessor :raw, :url

    def initialize(**attributes)
      self.raw = attributes[:raw]
      self.url = attributes[:url]
    end

    # Creates temporary pdfs for each label and then joins them. We also ensure
    # that temp files are deleted
    def self.generate_merged_pdf(decoded_labels)
      target = HexaPDF::Document.new
      decoded_labels.each_with_index do |decoded_label, i|
        file = Tempfile.new(["label-#{i}", 'pdf'])
        begin
          file.write(decoded_label.force_encoding('UTF-8'))
          pdf = HexaPDF::Document.open(file)
          pdf.pages.each { |page| target.pages << target.import(page) }
        ensure
          file.close
          file.unlink
        end
      end

      target
    end
  end
end
