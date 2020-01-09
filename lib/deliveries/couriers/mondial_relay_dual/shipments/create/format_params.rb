module Deliveries
  module Couriers
    module MondialRelayDual
      module Shipments
        class Create
          class FormatParams
            attr_accessor :sender, :receiver, :parcels, :reference_code, :collection_point, :remarks, :language

            def initialize(sender:, receiver:, parcels:, reference_code:, collection_point:, remarks:, language:)
              self.sender = sender.courierize(:mondial_relay_dual)
              self.receiver = receiver.courierize(:mondial_relay_dual)
              self.parcels = parcels
              self.reference_code = reference_code
              self.collection_point = collection_point
              self.remarks = remarks
              self.language = language
            end

            def execute
              {
                culture: culture,
                order_no: reference_code,
                parcel_count: parcels.to_i,
                delivery_mode: delivery_mode,
                collection_mode: collection_mode,
                deliver_instruction: remarks,
                parcels: parcel_list,
                sender: {
                  streetname: sender.street,
                  country_code: sender.country,
                  post_code: sender.postcode,
                  city: sender.city,
                  address_add_1: sender.name,
                  phone_no: sender.phone,
                  email: sender.email
                },
                recipient: {
                  streetname: receiver.street,
                  country_code: receiver.country,
                  post_code: receiver.postcode,
                  city: receiver.city,
                  address_add_1: receiver.name,
                  phone_no: receiver.phone,
                  email: receiver.email
                }
              }
            end

            private

            def culture
              case language.to_s.downcase
              when 'es' then 'es-ES'
              when 'de' then 'de-DE'
              when 'en' then 'en-GB'
              else 'fr-FR'
              end
            end

            def delivery_mode
              if collection_point
                {
                  mode: '24R',
                  location: collection_point.point_id
                }
              else
                {
                  mode: 'HOM',
                  location: ''
                }
              end
            end

            def collection_mode
              {
                mode: 'CCC',
                location: ''
              }
            end

            def parcel_list
              list = []
              parcels.times do
                list << {
                  content: 'Vêtements',
                  weight: {
                    value: '1000',
                    unit: 'gr'
                  }
                }
              end

              list
            end
          end
        end
      end
    end
  end
end
