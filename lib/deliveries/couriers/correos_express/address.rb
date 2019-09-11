module Deliveries
  module Couriers
    module CorreosExpress
      class Address < Deliveries::Address
        def name
          @name.to_s[0, 40]
        end

        def street
          @street.to_s[0, 300]
        end

        def city
          @city.to_s[0, 40]
        end

        def phone
          @phone.to_s[0, 15]
        end

        def email
          @email.gsub(/\+.+@/, '@').to_s[0, 75]
        end

        def country
          @country.to_s.upcase
        end
      end
    end
  end
end
