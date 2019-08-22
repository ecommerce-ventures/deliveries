module Deliveries
    module Couriers
      class MondialRelayDual < Deliveries::Courier
        module Shipments
          class Create
            attr_accessor :params
  
            def initialize(params:)
              self.params = params
            end
  
            def execute
              config = Deliveries.courier('mondial_relay_dual').class_variable_get(:@@config)
              
              xml = "<?xml version='1.0' encoding='utf-8'?>
                <ShipmentCreationRequest xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
                xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns='http://www.example.org/Request'>
                <Context>
                  <Login>#{config.dual_carrier_login}</Login>
                  <Password>#{config.dual_carrier_password}</Password>
                  <CustomerId>#{config.dual_carrier_customer_id}</CustomerId>
                  <Culture>es-ES</Culture>
                  <VersionAPI>1.0</VersionAPI>
                </Context>
                <OutputOptions>
                  <OutputFormat>10x15</OutputFormat>
                  <OutputType>PdfUrl</OutputType>
                </OutputOptions>
                <ShipmentsList>
                  <Shipment>
                    <OrderNo>#{params['NDossier']}</OrderNo>
                    <CustomerNo></CustomerNo>
                    <ParcelCount>#{params['NbColis']}</ParcelCount>
                    <DeliveryMode Mode='#{params['ModeLiv']}' Location='' />
                    <CollectionMode Mode='#{params['ModeCol']}' Location='' />
                    <Parcels>
                      <Parcel>
                        <Content>Livres</Content>
                        <Weight Value='1000' Unit='gr' />
                      </Parcel>
                    </Parcels>
                    <DeliveryInstruction>#{params['Instructions']}</DeliveryInstruction>
                    <Sender>
                      <Address>
                        <Title />
                        <Firstname></Firstname>
                        <Lastname></Lastname>
                        <Streetname>#{params['Expe_Ad1']}</Streetname>
                        <HouseNo></HouseNo>
                        <CountryCode>#{params['Expe_Pays']}</CountryCode>
                        <PostCode>#{params['Expe_CP']}</PostCode>
                        <City>#{params['Expe_Ville']}</City>
                        <AddressAdd1>#{params['Expe_Ad1']}</AddressAdd1>
                        <AddressAdd2 />
                        <AddressAdd3>#{params['Expe_Ad3']}</AddressAdd3>
                        <PhoneNo>#{params['Expe_Tel1']}</PhoneNo>
                        <MobileNo></MobileNo>
                        <Email>#{params['Expe_Mail']}</Email>
                      </Address>
                    </Sender>
                    <Recipient>
                      <Address>
                      <Title />
                      <Firstname></Firstname>
                      <Lastname></Lastname>
                      <Streetname>#{params['Dest_Ad1']}</Streetname>
                      <HouseNo></HouseNo>
                      <CountryCode>#{params['Dest_Pays']}</CountryCode>
                      <PostCode>#{params['Dest_CP']}</PostCode>
                      <City>#{params['Dest_Ville']}</City>
                      <AddressAdd1>#{params['Dest_Ad1']}</AddressAdd1>
                      <AddressAdd2 />
                      <AddressAdd3>#{params['Dest_Ad3']}</AddressAdd3>
                      <PhoneNo>#{params['Dest_Tel1']}</PhoneNo>
                      <MobileNo></MobileNo>
                      <Email>#{params['Dest_Mail']}</Email>
                      </Address>
                    </Recipient>
                  </Shipment>
                </ShipmentsList>
                </ShipmentCreationRequest>"
  
                response = HTTParty.post(
                  api_endpoint,
                  body: xml,
                  headers: { "Content-Type" => "application/xml; charset='UTF-8'" }
                )
  
                response_result = Hash.from_xml(response.body)
                
                shipment_number = response_result.dig('ShipmentCreationResponse','ShipmentsList','Shipment','ShipmentNumber')
  
                pdf_url = response_result.dig(
                  'ShipmentCreationResponse',
                  'ShipmentsList',
                  'Shipment',
                  'LabelList',
                  'Label',
                  'Output'
                )
  
                puts pdf_url
                              
                if shipment_number.blank?
                  status_response = response_result.dig('ShipmentCreationResponse','StatusList')
                  if status_response.is_a?(Array)
                    message =  status_response.dig('Status')&.map{|s| s['Message']}
                    code =  status_response.dig('Status')&.map{|s| s['Code']}
                  else
                    message = status_response.dig('Status', 'Message')
                    code = status_response.dig('Status', 'Code')
                  end
  
                  raise Deliveries::APIError.new(message, code)
                end
  
                shipment_number
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
  