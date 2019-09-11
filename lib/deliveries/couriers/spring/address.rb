module Deliveries
  module Couriers
    module Spring
      class Address < Deliveries::Address
        def name
          @name.to_s[0, 35]
        end

        def street
          @street.to_s[0, 35]
        end

        def street2
          @street.to_s[35, 35].to_s
        end

        def street3
          @street.to_s[70, 35].to_s
        end
      end
    end
  end
end
