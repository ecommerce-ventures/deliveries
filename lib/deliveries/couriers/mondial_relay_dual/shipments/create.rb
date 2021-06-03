module Deliveries
  module Couriers
    module MondialRelayDual
      module Shipments
        class Create
          attr_accessor :params

          def initialize(params:)
            self.params = params
          end

          def execute
            builder = Nokogiri::XML::Builder.new(encoding: 'utf-8') do |xml|
              xml.ShipmentCreationRequest('xmlns:xsi0' => 'http://www.w3.org/2001/XMLSchema-instance',
                                          'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema', 'xmlns' => 'http://www.example.org/Request') do
                xml.Context do
                  xml.Login Deliveries::Couriers::MondialRelayDual.config(:dual_carrier_login)
                  xml.Password Deliveries::Couriers::MondialRelayDual.config(:dual_carrier_password)
                  xml.CustomerId Deliveries::Couriers::MondialRelayDual.config(:dual_carrier_customer_id)
                  xml.Culture params[:culture]
                  xml.VersionAPI '1.0'
                end

                xml.OutputOptions do
                  xml.OutputFormat '10x15'
                  xml.OutputType 'PdfUrl'
                end

                xml.ShipmentsList do
                  xml.Shipment do
                    xml.OrderNo params[:order_no]
                    xml.CustomerNo
                    xml.ParcelCount params[:parcel_count]
                    xml.DeliveryMode(Mode: params.dig(:delivery_mode, :mode),
                                     Location: params.dig(:delivery_mode,
                                                          :location))
                    xml.CollectionMode(Mode: params.dig(:collection_mode, :mode),
                                       Location: params.dig(:collection_mode,
                                                            :location))
                    xml.Parcels do
                      params[:parcels].each do |parcel|
                        xml.Parcel do
                          xml.Content parcel[:content]
                          xml.Weight(Value: parcel.dig(:weight, :value), Unit: parcel.dig(:weight, :unit))
                        end
                      end
                    end
                    xml.DeliveryInstruction params[:deliver_instruction]
                    xml.Sender do
                      xml.Address do
                        xml.Title
                        xml.Firstname
                        xml.Lastname
                        xml.Streetname params.dig(:sender, :streetname)
                        xml.HouseNo
                        xml.CountryCode params.dig(:sender, :country_code)
                        xml.PostCode params.dig(:sender, :post_code)
                        xml.City params.dig(:sender, :city)
                        xml.AddressAdd1 params.dig(:sender, :address_add_1)
                        xml.AddressAdd2
                        xml.AddressAdd3
                        xml.PhoneNo params.dig(:sender, :phone_no)
                        xml.MobileNo
                        xml.Email params.dig(:sender, :email)
                      end
                    end
                    xml.Recipient do
                      xml.Address do
                        xml.Title
                        xml.Firstname
                        xml.Lastname
                        xml.Streetname params.dig(:recipient, :streetname)
                        xml.HouseNo
                        xml.CountryCode params.dig(:recipient, :country_code)
                        xml.PostCode params.dig(:recipient, :post_code)
                        xml.City params.dig(:recipient, :city)
                        xml.AddressAdd1 params.dig(:recipient, :address_add_1)
                        xml.AddressAdd2
                        xml.AddressAdd3
                        xml.PhoneNo params.dig(:recipient, :phone_no)
                        xml.MobileNo
                        xml.Email params.dig(:recipient, :email)
                      end
                    end
                  end
                end
              end
            end

            response = HTTParty.post(
              api_endpoint,
              body: builder.to_xml,
              headers: { 'Content-Type': 'application/xml', Accept: 'application/xml' },
              debug_output: Deliveries.debug ? Deliveries.logger : nil
            )

            xml_doc = Nokogiri::XML(response.body, &:strict)
            xml_doc.remove_namespaces!

            shipment_number = xml_doc.xpath('//ShipmentCreationResponse/ShipmentsList/Shipment/@ShipmentNumber').first&.content
            pdf_url = xml_doc.xpath('//ShipmentCreationResponse/ShipmentsList/Shipment/LabelList/Label/Output').first&.content

            unless shipment_number && pdf_url
              error_node = xml_doc.xpath('//ShipmentCreationResponse/StatusList/Status').find do |n|
                %w[Critical\ Error Error].include?(n[:Level])
              end
              raise Deliveries::APIError.new(error_node[:Message], error_node[:Code]) if error_node

              raise Deliveries::ClientError, 'Cannot obtain error code from the API response'
            end

            {
              tracking_code: shipment_number,
              pdf_url: pdf_url
            }
          end

          private

          def api_endpoint
            if MondialRelayDual.live?
              MondialRelayDual::API_ENDPOINT_LIVE
            else
              MondialRelayDual::API_ENDPOINT_TEST
            end
          end
        end
      end
    end
  end
end
