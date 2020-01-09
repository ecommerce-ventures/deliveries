module Deliveries
  module Couriers
    module MondialRelayDual
      class Address < Deliveries::Address
        def name
          I18n.transliterate(@name.to_s).gsub(%r{[^0-9A-Z_\-'., /]}i, '').upcase.truncate(30, omission: '')
        end

        def street
          I18n.transliterate(@street.to_s).gsub(%r{[^0-9A-Z_\-'., /]}i, '').upcase.truncate(30, omission: '')
        end

        def city
          I18n.transliterate(@city.to_s).gsub(/[^A-Z_\-' ]/i, '').upcase.truncate(30, omission: '')
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

        private

        COUNTRY_PHONE_PREFIXES = {
          be: 32,
          fr: 33,
          es: 34,
          it: 39,
          gb: 44,
          de: 49,
          pt: 351
        }.freeze

        COUNTRY_TRUNK_PREFIXES = {
          be: 0,
          fr: 0,
          es: nil,
          it: nil,
          gb: 0,
          de: 0,
          pt: nil
        }.freeze

        def format_international_phone
          return '' if @phone.blank? || @country.blank?

          country = @country.downcase.to_sym
          prefix = COUNTRY_PHONE_PREFIXES[country]
          trunk_prefix = COUNTRY_TRUNK_PREFIXES[country]

          # Remove white spaces.
          tmp_phone = @phone.gsub(' ', '')

          # Remove current prefix if present.
          tmp_phone.gsub!(/\A(00|\+)#{prefix}/, '')

          # Remove trunk prefix to convert it to international.
          tmp_phone.gsub!(/\A#{trunk_prefix}/, '') if trunk_prefix

          "+#{prefix}#{tmp_phone}"
        end

        def format_email
          return '' if @email.blank?

          matches = @email.split(/[+@]/)
          %(#{matches.first}@#{matches.last})
        end
      end
    end
  end
end
