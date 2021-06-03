module Deliveries
  module Couriers
    module Spring
      module Shipments
        class Create
          class FormatParams
            attr_accessor :sender, :receiver, :parcels, :reference_code

            def initialize(sender:, receiver:, parcels:, reference_code:)
              self.sender = sender
              self.receiver = receiver
              self.parcels = parcels
              self.reference_code = reference_code
            end

            def execute
              shipment = {
                ShipperReference: reference_code,
                Service: Deliveries::Couriers::Spring.config("countries.#{receiver.country.downcase.to_sym}.service")
              }

              # Consignor address (from).
              shipment[:ConsignorAddress] = {
                Name: sender.name,
                Company: sender.name,
                AddressLine1: sender.street,
                AddressLine2: sender.street2,
                AddressLine3: sender.street3,
                City: sender.city,
                State: sender.state,
                Zip: sender.postcode,
                Country: sender.country,
                Phone: sender.phone,
                Email: sender.email
              }

              # Consignee address (to).
              shipment[:ConsigneeAddress] = {
                Name: receiver.name,
                Company: '',
                AddressLine1: receiver.street,
                AddressLine2: receiver.street2,
                AddressLine3: receiver.street3,
                City: receiver.city,
                State: receiver.state,
                Zip: receiver.postcode,
                Country: receiver.country,
                Phone: receiver.phone,
                Email: receiver.email
              }

              # Products collection.
              shipment[:Products] = 1.upto(parcels).map do
                {
                  Description: Deliveries::Couriers::Spring.config('default_product.description'),
                  Sku: '',
                  HsCode: Deliveries::Couriers::Spring.config('default_product.hs_code'),
                  OriginCountry: Deliveries::Couriers::Spring.config('default_product.origin_country'),
                  PurchaseUrl: '',
                  Quantity: Deliveries::Couriers::Spring.config('default_product.quantity'),
                  Value: Deliveries::Couriers::Spring.config('default_product.value')
                }
              end

              params = {
                Apikey: Deliveries::Couriers::Spring.config(:api_key),
                Shipment: shipment
              }

              Defaults::PARAMS.deep_merge(params)
            end
          end
        end
      end
    end
  end
end
