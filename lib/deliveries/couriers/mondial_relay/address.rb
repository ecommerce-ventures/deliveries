module Deliveries
  module Couriers
    module MondialRelay
      class Address < Deliveries::Address
        def name
          I18n.transliterate(@name.to_s).gsub(/[^0-9A-Z_\-'., \/]/i, '').upcase.truncate(32, omission: '')
        end

        def street
          I18n.transliterate(@street.to_s).gsub(/[^0-9A-Z_\-'., \/]/i, '').upcase.truncate(32, omission: '')
        end

        def city
          I18n.transliterate(@city.to_s).gsub(/[^A-Z_\-' ]/i, '').upcase.truncate(25, omission: '')
        end

        def country
          @country.to_s.upcase
        end

        def phone
          format_phone
        end

        def email
          format_email
        end

        private

        SPAIN_PHONE_NUMBER_REGEXP = /^(\+34|0034|34)?[6|7|9][0-9]{8}$/.freeze
        FRANCE_PHONE_NUMBER_REGEXP = /^((00|\+)33|0)[1-9][0-9]{8}$/.freeze

        def format_phone
          return '' if @phone.blank? || @country.blank?

          # Remove white spaces.
          dest_phone = @phone.gsub(' ','')
          if @country.downcase.to_sym == :fr
            # If it only has 9 characters put a 0 at the beggining.
            dest_phone = "0#{dest_phone}" unless dest_phone.length > 9
          end

          # Phone must match the following regexp.
          regexp = case @country.downcase.to_sym
                   when :es
                     SPAIN_PHONE_NUMBER_REGEXP
                   when :fr
                     FRANCE_PHONE_NUMBER_REGEXP
                   else
                     dest_phone
                   end

          ( regexp === dest_phone ) ? dest_phone : ''
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
