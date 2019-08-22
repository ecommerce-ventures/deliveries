module Deliveries
  module Couriers
    class MondialRelay < Deliveries::Courier
      module Utils
        module_function

        SPAIN_PHONE_NUMBER_REGEXP = /^(\+34|0034|34)?[6|7|9][0-9]{8}$/.freeze
        FRANCE_PHONE_NUMBER_REGEXP = /^((00|\+)33|0)[1-9][0-9]{8}$/.freeze

        def format_phone(phone, country)
          return '' if phone.blank? || country.blank?

          # Remove white spaces.
          dest_phone = phone.gsub(' ','')
          if country.downcase.to_sym == :fr
            # If it only has 9 characters put a 0 at the beggining.
            dest_phone = "0#{dest_phone}" unless dest_phone.length > 9
          end

          # Phone must match the following regexp.
          regexp = case country.downcase.to_sym
                   when :es
                     SPAIN_PHONE_NUMBER_REGEXP
                   when :fr
                     FRANCE_PHONE_NUMBER_REGEXP
                   else
                     dest_phone
                   end

          ( regexp === dest_phone ) ? dest_phone : ''
        end

        def format_email(email)
          return '' if email.blank?

          matches = email.split(/[+@]/)
          %(#{matches.first}@#{matches.last})
        end
      end
    end
  end
end
