require 'mini_magick'
require 'hexapdf'

module Deliveries
  module LabelUtils
    module_function

    def image2pdf(bindata, width: nil, height: nil)
      Tempfile.create do |f|
        f.binmode

        f << bindata

        image = MiniMagick::Image.open(f.path)
        image.format 'png' unless image.data['format']&.casecmp?('png')

        doc = HexaPDF::Document.new
        doc_image = doc.images.add(image.path)
        iw = doc_image.info.width.to_f
        ih = doc_image.info.height.to_f
        media_box =
          if width.nil? && height.nil?
            [0, 0, iw, ih]
          elsif width.nil?
            width = (height * iw) / ih
            [0, 0, width * 72, height * 72]
          elsif height.nil?
            height = (width * ih) / iw
            [0, 0, width * 72, height * 72]
          else # rubocop:disable Lint/DuplicateBranch
            [0, 0, iw, ih]
          end

        if (ih > iw) != (media_box[3] > media_box[2]) && (iw > media_box[2] || ih > media_box[3])
          media_box[2], media_box[3] = media_box[3], media_box[2]
        end

        page = doc.pages.add(media_box)
        pw = page.box(:media).width.to_f
        ph = page.box(:media).height.to_f
        ratio = [pw / iw, ph / ih].min
        iw *= ratio
        ih *= ratio
        x = (pw - iw) / 2
        y = (ph - ih) / 2
        page.canvas.image(doc_image, at: [x, y], width: iw, height: ih)

        output = StringIO.new
        doc.write(output)
        output.string.force_encoding('binary')
      end
    end

    def merge_pdfs(*pdfs)
      doc = HexaPDF::Document.new
      pdfs.flatten.each do |pdf|
        HexaPDF::Document.new(io: StringIO.new(pdf)).pages.each do |page|
          doc.pages << doc.import(page)
        end
      end

      output = StringIO.new
      doc.write(output)
      output.string.force_encoding('binary')
    end
  end
end
