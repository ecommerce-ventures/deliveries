def register_mondial_relay_dual_create_shipment_stubs

  # Success
  # ---

  stub_request(:post, "https://connect-api-sandbox.mondialrelay.com/api/shipment").
    with(
    body: <<~XML,
      <?xml version="1.0" encoding="utf-8"?>
      <ShipmentCreationRequest xmlns:xsi0="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://www.example.org/Request">
        <Context>
          <Login>test</Login>
          <Password>test</Password>
          <CustomerId>test</CustomerId>
          <Culture>es-ES</Culture>
          <VersionAPI>1.0</VersionAPI>
        </Context>
        <OutputOptions>
          <OutputFormat>10x15</OutputFormat>
          <OutputType>PdfUrl</OutputType>
        </OutputOptions>
        <ShipmentsList>
          <Shipment>
            <OrderNo>shipmentX</OrderNo>
            <CustomerNo/>
            <ParcelCount>1</ParcelCount>
            <DeliveryMode Mode="HOM" Location=""/>
            <CollectionMode Mode="CCC" Location=""/>
            <Parcels>
              <Parcel>
                <Content>Vêtements</Content>
                <Weight Value="1000" Unit="gr"/>
              </Parcel>
            </Parcels>
            <DeliveryInstruction/>
            <Sender>
              <Address>
                <Title/>
                <Firstname/>
                <Lastname/>
                <Streetname>SENDER STREET</Streetname>
                <HouseNo/>
                <CountryCode>ES</CountryCode>
                <PostCode>48950</PostCode>
                <City>ERANDIO</City>
                <AddressAdd1>SENDER NAME</AddressAdd1>
                <AddressAdd2/>
                <AddressAdd3/>
                <PhoneNo>+34999999999</PhoneNo>
                <MobileNo/>
                <Email>sender@example.com</Email>
              </Address>
            </Sender>
            <Recipient>
              <Address>
                <Title/>
                <Firstname/>
                <Lastname/>
                <Streetname>RECEIVER STREET</Streetname>
                <HouseNo/>
                <CountryCode>ES</CountryCode>
                <PostCode>48950</PostCode>
                <City>ERANDIO</City>
                <AddressAdd1>RECEIVER NAME</AddressAdd1>
                <AddressAdd2/>
                <AddressAdd3/>
                <PhoneNo>+34999999999</PhoneNo>
                <MobileNo/>
                <Email>receiver@example.com</Email>
              </Address>
            </Recipient>
          </Shipment>
        </ShipmentsList>
      </ShipmentCreationRequest>
    XML
    headers: {
      'Accept'=>'application/xml',
      'Content-Type'=>'application/xml'
    }).
    to_return(
      status: 200,
      body: <<~XML,
        <ShipmentCreationResponse xmlns="http://www.example.org/Response" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
          <Context>
            <Login>test</Login>
            <Password>test</Password>
            <CustomerId>test</CustomerId>
            <Culture>es-ES</Culture>
            <VersionAPI>1.0</VersionAPI>
          </Context>
          <OutputOptions>
            <OutputFormat>10x15</OutputFormat>
            <OutputType>PdfUrl</OutputType>
          </OutputOptions>
          <ShipmentsList>
            <Shipment ShipmentNumber="96671332">
              <LabelList>
                <Label>
                  <RawContent>
                    <Parcel/>
                    <Sender ZoneTitle="Remitente">
                      <AddressLines AddressLine="SENDER NAME" Order="1"/>
                      <AddressLines AddressLine="" Order="2"/>
                      <AddressLines AddressLine="SENDER STREET" Order="3"/>
                      <AddressLines AddressLine="" Order="4"/>
                      <AddressLines AddressLine="ES 48950 ERANDIO" Order="5"/>
                    </Sender>
                    <Recipient ZoneTitle="Destinatario">
                      <AddressLines AddressLine="SANDBOX MODE" Order="1"/>
                    </Recipient>
                    <LabelValues Key="MR.Expediteur.Libelle" Value="SENDER NAME"/>
                    <LabelValues Key="MR.Expediteur.LigneAdresse1" Value="SENDER STREET"/>
                    <LabelValues Key="MR.Expediteur.CodePays" Value="ES"/>
                    <LabelValues Key="MR.Expediteur.CodePostal" Value="48950"/>
                    <LabelValues Key="MR.Expediteur.Ville" Value="ERANDIO"/>
                    <LabelValues Key="MR.Destinataire.Libelle" Value="SANDBOX MODE"/>
                    <LabelValues Key="MR.Expedition.Sequence" Value="1"/>
                    <LabelValues Key="MR.Expedition.NombreColis" Value="1"/>
                    <LabelValues Key="MR.Expedition.ContenuColis" Value="Vêtements"/>
                    <LabelValues Key="MR.Expedition.NumeroExpedition" Value="SANDBOX MODE"/>
                    <LabelValues Key="MR.Expedition.Poids" Value="1,00"/>
                    <LabelValues Key="MR.Expedition.DateEnvoi" Value="19/12/2019"/>
                    <LabelValues Key="MR.Expedition.VolumeTotal" Value="0"/>
                    <LabelValues Key="MR.Expedition.CRT" Value="0,00"/>
                    <LabelValues Key="MR.Expedition.ReferenceExterne" Value="shipmentX"/>
                    <LabelValues Key="MR.Expedition.CodeBarresAAfficher" Value="SANDBOX MODE"/>
                    <LabelValues Key="MR.Expedition.CodeBarres" Value="SANDBOX MODE"/>
                    <LabelValues Key="MR.PlanTri.Mode" Value="HOM"/>
                    <LabelValues Key="MR.PlanTri.CodeAgence" Value="4220"/>
                    <LabelValues Key="MR.PlanTri.Tournee" Value="4220"/>
                    <LabelValues Key="MR.PlanTri.Navette" Value="4220"/>
                    <LabelValues Key="MR.PlanTri.CodePays" Value="ES"/>
                    <LabelValues Key="MR.PlanTri.LibelleAgence" Value="Correos ES"/>
                    <LabelValues Key="NomEtiquette" Value="Label_C_MR_L_MR_FR_10x15"/>
                    <LabelValues Key="ModeSandbox" Value="True"/>
                    <Barcodes>
                      <Barcode CarrierCode="MR" DisplayedValue="SANDBOX MODE" Type="Code128" Value="SANDBOX MODE"/>
                    </Barcodes>
                  </RawContent>
                  <Output>https://connect-sandbox.mondialrelay.com//BDTEST/etiquette/GetStickersExpeditionsAnonyme2?ens=BDTEST&amp;expedition=96671332&amp;lg=es-ES&amp;format=10x15&amp;crc=2D4FBA4AEEF3FD29F492397CFF65C48E</Output>
                </Label>
              </LabelList>
            </Shipment>
          </ShipmentsList>
          <StatusList>
            <Status Code="0" Message="API Mondial Relay Sandbox, aucune donnée n'a été enregistrée, le résultat ne peut être utilisé sur un flux de production."/>
          </StatusList>
        </ShipmentCreationResponse>
      XML
      headers: {}
    )

  # Error
  # ---

  stub_request(:post, "https://connect-api-sandbox.mondialrelay.com/api/shipment").
    with(
    body: <<~XML,
      <?xml version="1.0" encoding="utf-8"?>
      <ShipmentCreationRequest xmlns:xsi0="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://www.example.org/Request">
        <Context>
          <Login>test</Login>
          <Password>test</Password>
          <CustomerId>test</CustomerId>
          <Culture>es-ES</Culture>
          <VersionAPI>1.0</VersionAPI>
        </Context>
        <OutputOptions>
          <OutputFormat>10x15</OutputFormat>
          <OutputType>PdfUrl</OutputType>
        </OutputOptions>
        <ShipmentsList>
          <Shipment>
            <OrderNo>shipmentX</OrderNo>
            <CustomerNo/>
            <ParcelCount>1</ParcelCount>
            <DeliveryMode Mode="HOM" Location=""/>
            <CollectionMode Mode="CCC" Location=""/>
            <Parcels>
              <Parcel>
                <Content>Vêtements</Content>
                <Weight Value="1000" Unit="gr"/>
              </Parcel>
            </Parcels>
            <DeliveryInstruction/>
            <Sender>
              <Address>
                <Title/>
                <Firstname/>
                <Lastname/>
                <Streetname>SENDER STREET</Streetname>
                <HouseNo/>
                <CountryCode>ES</CountryCode>
                <PostCode>48950</PostCode>
                <City>ERANDIO</City>
                <AddressAdd1>SENDER NAME</AddressAdd1>
                <AddressAdd2/>
                <AddressAdd3/>
                <PhoneNo>+34999999999</PhoneNo>
                <MobileNo/>
                <Email>sender@example.com</Email>
              </Address>
            </Sender>
            <Recipient>
              <Address>
                <Title/>
                <Firstname/>
                <Lastname/>
                <Streetname>RECEIVER STREET</Streetname>
                <HouseNo/>
                <CountryCode>ES</CountryCode>
                <PostCode>48950</PostCode>
                <City>ERANDIO</City>
                <AddressAdd1>RECEIVER NAME</AddressAdd1>
                <AddressAdd2/>
                <AddressAdd3/>
                <PhoneNo/>
                <MobileNo/>
                <Email>receiver@example.com</Email>
              </Address>
            </Recipient>
          </Shipment>
        </ShipmentsList>
      </ShipmentCreationRequest>
    XML
    headers: {
      'Accept'=>'application/xml',
      'Content-Type'=>'application/xml'
    }).
    to_return(
      status: 200,
      body: <<~XML,
        <ShipmentCreationResponse xmlns="http://www.example.org/Response" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
          <StatusList>
            <Status Code="10051" Level="Error" Message="Service_Expedition_DomicileTelephoneRequis"/>
          </StatusList>
        </ShipmentCreationResponse>
      XML
      headers: {}
    )
end

def register_mondial_relay_dual_create_pickup_stubs

  # Success
  # ---

  stub_request(:post, "https://connect-api-sandbox.mondialrelay.com/api/shipment").
    with(
      body: <<~XML,
        <?xml version="1.0" encoding="utf-8"?>
        <ShipmentCreationRequest xmlns:xsi0="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://www.example.org/Request">
          <Context>
            <Login>test</Login>
            <Password>test</Password>
            <CustomerId>test</CustomerId>
            <Culture>es-ES</Culture>
            <VersionAPI>1.0</VersionAPI>
          </Context>
          <OutputOptions>
            <OutputFormat>10x15</OutputFormat>
            <OutputType>PdfUrl</OutputType>
          </OutputOptions>
          <ShipmentsList>
            <Shipment>
              <OrderNo>shipmentX</OrderNo>
              <CustomerNo/>
              <ParcelCount>1</ParcelCount>
              <DeliveryMode Mode="LCC" Location=""/>
              <CollectionMode Mode="REL" Location=""/>
              <Parcels>
                <Parcel>
                  <Content>Vêtements</Content>
                  <Weight Value="1000" Unit="gr"/>
                </Parcel>
              </Parcels>
              <DeliveryInstruction/>
              <Sender>
                <Address>
                  <Title/>
                  <Firstname/>
                  <Lastname/>
                  <Streetname>SENDER STREET</Streetname>
                  <HouseNo/>
                  <CountryCode>ES</CountryCode>
                  <PostCode>48950</PostCode>
                  <City>ERANDIO</City>
                  <AddressAdd1>SENDER NAME</AddressAdd1>
                  <AddressAdd2/>
                  <AddressAdd3/>
                  <PhoneNo>+34999999999</PhoneNo>
                  <MobileNo/>
                  <Email>sender@example.com</Email>
                </Address>
              </Sender>
              <Recipient>
                <Address>
                  <Title/>
                  <Firstname/>
                  <Lastname/>
                  <Streetname>RECEIVER STREET</Streetname>
                  <HouseNo/>
                  <CountryCode>ES</CountryCode>
                  <PostCode>48950</PostCode>
                  <City>ERANDIO</City>
                  <AddressAdd1>RECEIVER NAME</AddressAdd1>
                  <AddressAdd2/>
                  <AddressAdd3/>
                  <PhoneNo>+34999999999</PhoneNo>
                  <MobileNo/>
                  <Email>receiver@example.com</Email>
                </Address>
              </Recipient>
            </Shipment>
          </ShipmentsList>
        </ShipmentCreationRequest>
      XML
      headers: {
        'Accept'=>'application/xml',
        'Content-Type'=>'application/xml'
      }).
    to_return(
      status: 200,
      body: <<~XML,
      <ShipmentCreationResponse xmlns="http://www.example.org/Response" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <Context>
          <Login>test</Login>
          <Password>test</Password>
          <CustomerId>test</CustomerId>
          <Culture>es-ES</Culture>
          <VersionAPI>1.0</VersionAPI>
        </Context>
        <OutputOptions>
          <OutputFormat>10x15</OutputFormat>
          <OutputType>PdfUrl</OutputType>
        </OutputOptions>
        <ShipmentsList>
          <Shipment ShipmentNumber="96671335">
            <LabelList>
              <Label>
                <RawContent>
                  <Parcel/>
                  <Sender ZoneTitle="Expediteur">
                    <AddressLines AddressLine="SENDER NAME" Order="1"/>
                    <AddressLines AddressLine="" Order="2"/>
                    <AddressLines AddressLine="SENDER STREET" Order="3"/>
                    <AddressLines AddressLine="" Order="4"/>
                    <AddressLines AddressLine="ES 48950 ERANDIO" Order="5"/>
                  </Sender>
                  <Recipient ZoneTitle="Destinataire">
                    <AddressLines AddressLine="SANDBOX MODE" Order="1"/>
                  </Recipient>
                  <LabelValues Key="MR.Expediteur.Libelle" Value="SENDER NAME"/>
                  <LabelValues Key="MR.Expediteur.LigneAdresse1" Value="SENDER STREET"/>
                  <LabelValues Key="MR.Expediteur.CodePays" Value="ES"/>
                  <LabelValues Key="MR.Expediteur.CodePostal" Value="48950"/>
                  <LabelValues Key="MR.Expediteur.Ville" Value="ERANDIO"/>
                  <LabelValues Key="MR.Destinataire.Libelle" Value="SANDBOX MODE"/>
                  <LabelValues Key="MR.Expedition.Sequence" Value="1"/>
                  <LabelValues Key="MR.Expedition.NombreColis" Value="1"/>
                  <LabelValues Key="MR.Expedition.ContenuColis" Value="Vêtements"/>
                  <LabelValues Key="MR.Expedition.NumeroExpedition" Value="SANDBOX MODE"/>
                  <LabelValues Key="MR.Expedition.Poids" Value="1,00"/>
                  <LabelValues Key="MR.Expedition.DateEnvoi" Value="19/12/2019"/>
                  <LabelValues Key="MR.Expedition.VolumeTotal" Value="0"/>
                  <LabelValues Key="MR.Expedition.CRT" Value="0,00"/>
                  <LabelValues Key="MR.Expedition.ReferenceExterne" Value="shipmentX"/>
                  <LabelValues Key="MR.Expedition.CodeBarresAAfficher" Value="SANDBOX MODE"/>
                  <LabelValues Key="MR.Expedition.CodeBarres" Value="SANDBOX MODE"/>
                  <LabelValues Key="MR.PlanTri.Mode" Value="LCC"/>
                  <LabelValues Key="MR.PlanTri.CodeAgence" Value="4010"/>
                  <LabelValues Key="MR.PlanTri.Tournee" Value="148"/>
                  <LabelValues Key="MR.PlanTri.Navette" Value="4010"/>
                  <LabelValues Key="MR.PlanTri.CodePays" Value="ES"/>
                  <LabelValues Key="MR.PlanTri.LibelleAgence" Value="Barcelona"/>
                  <LabelValues Key="NomEtiquette" Value="Label_C_MR_L_MR_FR_10x15"/>
                  <LabelValues Key="ModeSandbox" Value="True"/>
                  <Barcodes>
                    <Barcode CarrierCode="MR" DisplayedValue="SANDBOX MODE" Type="Code128" Value="SANDBOX MODE"/>
                  </Barcodes>
                </RawContent>
                <Output>https://connect-sandbox.mondialrelay.com//BDTEST/etiquette/GetStickersExpeditionsAnonyme2?ens=BDTEST&amp;expedition=96671335&amp;lg=fr-FR&amp;format=10x15&amp;crc=59A88FDCEA84F5141B0AC00B28E1515C</Output>
              </Label>
            </LabelList>
          </Shipment>
        </ShipmentsList>
        <StatusList>
          <Status Code="0" Message="API Mondial Relay Sandbox, aucune donnée n'a été enregistrée, le résultat ne peut être utilisé sur un flux de production."/>
        </StatusList>
      </ShipmentCreationResponse>
      XML
      headers: {}
    )

  # Error
  # ---

  stub_request(:post, "https://connect-api-sandbox.mondialrelay.com/api/shipment").
    with(
      body: <<~XML,
        <?xml version="1.0" encoding="utf-8"?>
        <ShipmentCreationRequest xmlns:xsi0="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://www.example.org/Request">
          <Context>
            <Login>test</Login>
            <Password>test</Password>
            <CustomerId>test</CustomerId>
            <Culture>es-ES</Culture>
            <VersionAPI>1.0</VersionAPI>
          </Context>
          <OutputOptions>
            <OutputFormat>10x15</OutputFormat>
            <OutputType>PdfUrl</OutputType>
          </OutputOptions>
          <ShipmentsList>
            <Shipment>
              <OrderNo>shipmentX</OrderNo>
              <CustomerNo/>
              <ParcelCount>1</ParcelCount>
              <DeliveryMode Mode="LCC" Location=""/>
              <CollectionMode Mode="REL" Location=""/>
              <Parcels>
                <Parcel>
                  <Content>Vêtements</Content>
                  <Weight Value="1000" Unit="gr"/>
                </Parcel>
              </Parcels>
              <DeliveryInstruction/>
              <Sender>
                <Address>
                  <Title/>
                  <Firstname/>
                  <Lastname/>
                  <Streetname>SENDER STREET</Streetname>
                  <HouseNo/>
                  <CountryCode>ES</CountryCode>
                  <PostCode>48950</PostCode>
                  <City>ERANDIO</City>
                  <AddressAdd1>SENDER NAME</AddressAdd1>
                  <AddressAdd2/>
                  <AddressAdd3/>
                  <PhoneNo>+34999999999</PhoneNo>
                  <MobileNo/>
                  <Email>sender@example.com</Email>
                </Address>
              </Sender>
              <Recipient>
                <Address>
                  <Title/>
                  <Firstname/>
                  <Lastname/>
                  <Streetname>RECEIVER STREET</Streetname>
                  <HouseNo/>
                  <CountryCode>ES</CountryCode>
                  <PostCode>48950</PostCode>
                  <City/>
                  <AddressAdd1>RECEIVER NAME</AddressAdd1>
                  <AddressAdd2/>
                  <AddressAdd3/>
                  <PhoneNo>+34999999999</PhoneNo>
                  <MobileNo/>
                  <Email>receiver@example.com</Email>
                </Address>
              </Recipient>
            </Shipment>
          </ShipmentsList>
        </ShipmentCreationRequest>
      XML
      headers: {
        'Accept'=>'application/xml',
        'Content-Type'=>'application/xml'
      }).
    to_return(
      status: 200,
      body: <<~XML,
        <ShipmentCreationResponse xmlns="http://www.example.org/Response" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
          <StatusList>
            <Status Code="10047" Level="Error" Message="Ciudad vacia para la dirección Destinatario."/>
          </StatusList>
        </ShipmentCreationResponse>
      XML
      headers: {}
    )
end
