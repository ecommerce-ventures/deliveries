module Deliveries
  module Couriers
    module CorreosExpress
      module Pickups
        class CutoffTime
          class FormatParams
            attr_accessor :country, :postcode

            def initialize(country:, postcode:)
              self.country = country
              self.postcode = postcode
            end

            def execute
              params = {
                strCP: postcode,
                strPais: country_code_to_id(country)
              }

              params.to_json
            end

            private

            def country_code_to_id(country_code)
              case country_code.to_sym.downcase
              when :es
                '34'
              when :pt
                '35'
              else
                raise Deliveries::Error, "Invalid country #{country_code}"
              end
            end
          end
        end
      end
    end
  end
end
