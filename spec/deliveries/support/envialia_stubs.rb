def register_envialia_login_stubs
  # Success
  # ---

  stub_request(:post, "http://wstest.envialia.com:9085/SOAP?service=LoginService").
    with(
      body: "<?xml version='1.0' encoding='utf-8'?>\n            <soap:Envelope\n              xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'\n              xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'\n              xmlns:xsd='http://www.w3.org/2001/XMLSchema'>\n              <soap:Body>\n                <LoginWSService___LoginCli2>\n                <strCodAge>test</strCodAge>\n                <strCliente>test</strCliente>\n                <strPass>test</strPass>\n                </LoginWSService___LoginCli2>\n              </soap:Body>\n          </soap:Envelope>",
    headers: {
      'Accept'=>'*/*',
      'Content-Type'=>"text/json; charset='UTF-8'",
    }).
    to_return(
      status: 200,
      body: <<~XML,
        <?xml version="1.0" encoding="utf-8"?>
          <SOAP-ENV:Envelope
          xmlns:xsd="http://www.w3.org/2001/XMLSchema"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:HNS="http://tempuri.org/"
          xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
          xmlns:v1="http://tempuri.org/">
          <SOAP-ENV:Header>
            <ROClientIDHeader SOAP-ENV:mustUnderstand="0"
              xmlns="urn:envialianet">
              <ID>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</ID>
            </ROClientIDHeader>
          </SOAP-ENV:Header>
          <SOAP-ENV:Body
            xmlns:ro="http://tempuri.org/">
            <v1:LoginWSService___LoginCli2Response>
              <v1:Result>true</v1:Result>
              <v1:strCodAgeOut>test</v1:strCodAgeOut>
              <v1:strCod>test</v1:strCod>
              <v1:strNom>test</v1:strNom>
              <v1:strCodCR>CT</v1:strCodCR>
              <v1:strTipo>4</v1:strTipo>
              <v1:strVersion>0.00.67</v1:strVersion>
              <v1:strError>0</v1:strError>
              <v1:strSesion>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</v1:strSesion>
              <v1:strURLDetSegEnv>http://81.46.198.83/validacion/envialianetweb/detalle_envio.php?servicio={GUID}&amp;fecha={FECHA}</v1:strURLDetSegEnv>
            </v1:LoginWSService___LoginCli2Response>
          </SOAP-ENV:Body>
        </SOAP-ENV:Envelope>
      XML
      headers: {}
    )
end

def register_envialia_create_shipment_stubs

  login_request

  stub_request(:post, "http://wstest.envialia.com:9085/SOAP?service=WebServService").
    with(
      body: "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">\n  <soap:Header>\n    <ROClientIDHeader xmlns=\"http://tempuri.org/\">\n      <ID>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</ID>\n    </ROClientIDHeader>\n  </soap:Header>\n  <soap:Body>\n    <WebServService___GrabaEnvio8 xmlns=\"http://tempuri.org/\">\n      <strCodAgeCargo>002800</strCodAgeCargo>\n      <strCodAgeOri>002800</strCodAgeOri>\n      <dtFecha>2021/11/05</dtFecha>\n      <strCodTipoServ>72</strCodTipoServ>\n      <strCodCli>1004</strCodCli>\n      <strNomOri>Sender name</strNomOri>\n      <strDirOri>Sender street</strDirOri>\n      <strCPOri>48950</strCPOri>\n      <strTlfOri>666666666</strTlfOri>\n      <strNomDes>Receiver name</strNomDes>\n      <strDirDes>Receiver street</strDirDes>\n      <strCPDes>48950</strCPDes>\n      <strTlfDes>666666666</strTlfDes>\n      <intDoc>0</intDoc>\n      <intPaq>1</intPaq>\n      <dPesoOri>0</dPesoOri>\n      <dAltoOri>0</dAltoOri>\n      <dAnchoOri>0</dAnchoOri>\n      <dLargoOri>0</dLargoOri>\n      <dReembolso>0</dReembolso>\n      <dValor>0</dValor>\n      <dAnticipo>0</dAnticipo>\n      <dCobCli>0</dCobCli>\n      <strObs></strObs>\n      <boSabado>false</boSabado>\n      <boRetorno>false</boRetorno>\n      <boGestOri>false</boGestOri>\n      <boGestDes>false</boGestDes>\n      <boAnulado>false</boAnulado>\n      <boAcuse>false</boAcuse>\n      <strRef>shipmentX</strRef>\n      <dBaseImp>0</dBaseImp>\n      <dImpuesto>0</dImpuesto>\n      <boPorteDebCli>false</boPorteDebCli>\n      <strDesDirEmails>receiver@example.com</strDesDirEmails>\n      <boInsert>true</boInsert>\n      <boCampo5>false</boCampo5>\n      <boPagoDUAImp>false</boPagoDUAImp>\n      <boPagoImpDes>false</boPagoImpDes>\n    </WebServService___GrabaEnvio8>\n  </soap:Body>\n</soap:Envelope>\n",
      headers: {
 	      'Accept'=>'*/*',
 	      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
 	      'Content-Type'=>"application/xml; charset='UTF-8'",
 	      'User-Agent'=>'Ruby'
      }
    ).to_return(
      status: 200,
      body: <<~XML,
        <?xml version="1.0" encoding="utf-8"?>
        <SOAP-ENV:Envelope
          xmlns:xsd="http://www.w3.org/2001/XMLSchema"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:HNS="http://tempuri.org/"
          xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
          xmlns:v1="http://tempuri.org/">
          <SOAP-ENV:Header>
            <ROClientIDHeader SOAP-ENV:mustUnderstand="0"
              xmlns="urn:envialianet">
              <ID>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</ID>
            </ROClientIDHeader>
          </SOAP-ENV:Header>
          <SOAP-ENV:Body
            xmlns:ro="http://tempuri.org/">
            <v1:WebServService___GrabaEnvio8Response>
              <v1:strAlbaranOut>0128346565</v1:strAlbaranOut>
              <v1:strCodTipoServOut>24</v1:strCodTipoServOut>
              <v1:dPesoVolpesOut>0</v1:dPesoVolpesOut>
              <v1:dAltoVolpesOut>0</v1:dAltoVolpesOut>
              <v1:dAnchoVolpesOut>0</v1:dAnchoVolpesOut>
              <v1:dLargoVolpesOut>0</v1:dLargoVolpesOut>
              <v1:dtFecEntrOut>1900-01-01T00:00:00</v1:dtFecEntrOut>
              <v1:strTipoEnvOut>N</v1:strTipoEnvOut>
              <v1:dtFecHoraAltaOut>2021-11-03T02:39:36.1</v1:dtFecHoraAltaOut>
              <v1:dKmsManOut>0</v1:dKmsManOut>
              <v1:boTecleDesOut>false</v1:boTecleDesOut>
              <v1:strCodAgeOriOut>002800</v1:strCodAgeOriOut>
              <v1:strCodAgeDesOut>004612</v1:strCodAgeDesOut>
              <v1:strCodProOriOut>46</v1:strCodProOriOut>
              <v1:strCodProDesOut>46</v1:strCodProDesOut>
              <v1:dPorteDebOut>0</v1:dPorteDebOut>
              <v1:strCodPaisOut></v1:strCodPaisOut>
              <v1:boRetornoOut>false</v1:boRetornoOut>
              <v1:strGuidOut>{5ED0BCD7-0455-4862-8E97-FD6022AA8750}</v1:strGuidOut>
            </v1:WebServService___GrabaEnvio8Response>
          </SOAP-ENV:Body>
        </SOAP-ENV:Envelope>
      XML
      headers: {}
    )
end

def register_envialia_create_pickup_stubs
  login_request

  stub_request(:post, "http://wstest.envialia.com:9085/SOAP?service=WebServService").
    with(
      body: "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">\n  <soap:Header>\n    <ROClientIDHeader xmlns=\"http://tempuri.org/\">\n      <ID>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</ID>\n    </ROClientIDHeader>\n  </soap:Header>\n  <soap:Body>\n    <WebServService___GrabaEnvio8 xmlns=\"http://tempuri.org/\">\n      <strCodAgeCargo>002800</strCodAgeCargo>\n      <strCodAgeOri>002800</strCodAgeOri>\n      <dtFecha>2021/11/05</dtFecha>\n      <strCodTipoServ>72</strCodTipoServ>\n      <strCodCli>1004</strCodCli>\n      <strNomOri>Sender name</strNomOri>\n      <strDirOri>Sender street</strDirOri>\n      <strCPOri>48950</strCPOri>\n      <strTlfOri>666666666</strTlfOri>\n      <strNomDes>Receiver name</strNomDes>\n      <strDirDes>Receiver street</strDirDes>\n      <strCPDes>48950</strCPDes>\n      <strTlfDes>666666666</strTlfDes>\n      <intDoc>0</intDoc>\n      <intPaq>1</intPaq>\n      <dPesoOri>0</dPesoOri>\n      <dAltoOri>0</dAltoOri>\n      <dAnchoOri>0</dAnchoOri>\n      <dLargoOri>0</dLargoOri>\n      <dReembolso>0</dReembolso>\n      <dValor>0</dValor>\n      <dAnticipo>0</dAnticipo>\n      <dCobCli>0</dCobCli>\n      <strObs></strObs>\n      <boSabado>false</boSabado>\n      <boRetorno>false</boRetorno>\n      <boGestOri>false</boGestOri>\n      <boGestDes>false</boGestDes>\n      <boAnulado>false</boAnulado>\n      <boAcuse>false</boAcuse>\n      <strRef>shipmentX</strRef>\n      <dBaseImp>0</dBaseImp>\n      <dImpuesto>0</dImpuesto>\n      <boPorteDebCli>false</boPorteDebCli>\n      <strDesDirEmails>receiver@example.com</strDesDirEmails>\n      <boInsert>true</boInsert>\n      <boCampo5>false</boCampo5>\n      <boPagoDUAImp>false</boPagoDUAImp>\n      <boPagoImpDes>false</boPagoImpDes>\n    </WebServService___GrabaEnvio8>\n  </soap:Body>\n</soap:Envelope>\n",
      headers: {
 	      'Accept'=>'*/*',
 	      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
 	      'Content-Type'=>"application/xml; charset='UTF-8'",
 	      'User-Agent'=>'Ruby'
      }
    ).to_return(
      status: 200,
      body: <<~XML,
      <?xml version="1.0" encoding="utf-8"?>
        <SOAP-ENV:Envelope
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:HNS="http://tempuri.org/"
        xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:v1="http://tempuri.org/">
        <SOAP-ENV:Header>
          <ROClientIDHeader SOAP-ENV:mustUnderstand="0"
            xmlns="urn:envialianet">
            <ID>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</ID>
          </ROClientIDHeader>
        </SOAP-ENV:Header>
          <SOAP-ENV:Body xmlns:ro="http://tempuri.org/">
            <v1:WebServService___GrabaRecogida3Response>
              <v1:strCodOut>0023104927</v1:strCodOut>
              <v1:strTipoRecOut>N</v1:strTipoRecOut>
              <v1:dtFecHoraAltaOut>2021-11-09T20:33:04</v1:dtFecHoraAltaOut>
              <v1:strCodAgeOriOut>004612</v1:strCodAgeOriOut>
              <v1:strCodProOriOut>46</v1:strCodProOriOut>
              <v1:strCodAgeDesOut>004612</v1:strCodAgeDesOut>
              <v1:strCodProDesOut>46</v1:strCodProDesOut>
              <v1:fPorteDebOut>0</v1:fPorteDebOut>
            </v1:WebServService___GrabaRecogida3Response>
          </SOAP-ENV:Body>
        </SOAP-ENV:Envelope>
      XML
      headers: {}
    )
end

def login_request
  # Stub login request
  allow(HTTParty).to receive(:post).and_return(
    '<?xml version="1.0" encoding="utf-8"?>
      <SOAP-ENV:Envelope
      xmlns:xsd="http://www.w3.org/2001/XMLSchema"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:HNS="http://tempuri.org/"
      xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:v1="http://tempuri.org/">
      <SOAP-ENV:Header>
        <ROClientIDHeader SOAP-ENV:mustUnderstand="0"
          xmlns="urn:envialianet">
          <ID>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</ID>
        </ROClientIDHeader>
      </SOAP-ENV:Header>
      <SOAP-ENV:Body
        xmlns:ro="http://tempuri.org/">
        <v1:LoginWSService___LoginCli2Response>
          <v1:Result>true</v1:Result>
          <v1:strCodAgeOut>test</v1:strCodAgeOut>
          <v1:strCod>test</v1:strCod>
          <v1:strNom>test</v1:strNom>
          <v1:strCodCR>CT</v1:strCodCR>
          <v1:strTipo>4</v1:strTipo>
          <v1:strVersion>0.00.67</v1:strVersion>
          <v1:strError>0</v1:strError>
          <v1:strSesion>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</v1:strSesion>
          <v1:strURLDetSegEnv>http://81.46.198.83/validacion/envialianetweb/detalle_envio.php?servicio={GUID}&amp;fecha={FECHA}</v1:strURLDetSegEnv>
        </v1:LoginWSService___LoginCli2Response>
      </SOAP-ENV:Body>
    </SOAP-ENV:Envelope>'
  )
end
