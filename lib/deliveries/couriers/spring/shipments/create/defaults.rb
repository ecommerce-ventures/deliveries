module Deliveries
  module Couriers
    module Spring
      module Shipments
        class Create
          module Defaults
            PARAMS = {
              "Apikey": "",
              "Command": "OrderShipment",
              "Shipment": {
                "LabelFormat": "PDF",
                "ShipperReference": "",
                "DisplayId": "",
                "InvoiceNumber": "",
                "Service": "",
                "ConsignorAddress": {
                  "Name": "",
                  "Company": "",
                  "AddressLine1": "",
                  "AddressLine2": "",
                  "AddressLine3": "",
                  "City": "",
                  "State": "",
                  "Zip": "",
                  "Country": "",
                  "Phone": "",
                  "Email": "",
                  "Vat": ""
                },
                "ConsigneeAddress": {
                  "Name": "",
                  "Company": "",
                  "AddressLine1": "",
                  "AddressLine2": "",
                  "AddressLine3": "",
                  "City": "",
                  "State": "",
                  "Zip": "",
                  "Country": "",
                  "Phone": "",
                  "Email": "",
                  "Vat": ""
                },
                "Weight": "1",
                "WeightUnit": "kg",
                "Length": "",
                "Width": "",
                "Height": "",
                "DimUnit": "",
                "Value": "",
                "Currency": "EUR",
                "CustomsDuty": "DDU",
                "Description": "",
                "DeclarationType": "SaleOfGoods",
                "Products": [
                  {
                    "Description": "",
                    "Sku": "",
                    "HsCode": "",
                    "OriginCountry": "",
                    "PurchaseUrl": "",
                    "Quantity": "",
                    "Value": ""
                  }
                ]
              }
            }.freeze
          end
        end
      end
    end
  end
end
