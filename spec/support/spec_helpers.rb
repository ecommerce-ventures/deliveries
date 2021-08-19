# frozen_string_literal: true

module SpecHelpers
  def pdf_pages_count(file_contents)
    file = Tempfile.new(['tmpfile', '.pdf'], encoding: 'ascii-8bit')
    file.write(file_contents)
    file.close
    %x(pdfinfo "#{file.path}" | grep Pages | sed 's/[^0-9]*//').to_i
  end
end
