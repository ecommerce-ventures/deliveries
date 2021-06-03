module Deliveries
  module Couriers
    module MondialRelay
      class Address < Deliveries::Address
        def name
          I18n.transliterate(@name.to_s).gsub(%r{[^0-9A-Z_\-'., /]}i, '').upcase.truncate(32, omission: '')
        end

        def street
          I18n.transliterate(@street.to_s).gsub(%r{[^0-9A-Z_\-'., /]}i, '').upcase.truncate(32, omission: '')
        end

        def city
          I18n.transliterate(@city.to_s).gsub(/[^A-Z_\-' ]/i, '').upcase.truncate(25, omission: '')
        end

        def country
          @country.to_s.upcase
        end

        def phone
          format_international_phone
        end

        def email
          format_email
        end
      end
    end
  end
end
