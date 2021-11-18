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

  # Success
  # ---

  stub_request(:post, "http://wstest.envialia.com:9085/SOAP?service=WebServService").
    with(
      body: "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">\n  <soap:Header>\n    <ROClientIDHeader xmlns=\"http://tempuri.org/\">\n      <ID>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</ID>\n    </ROClientIDHeader>\n  </soap:Header>\n  <soap:Body>\n    <WebServService___GrabaEnvio8 xmlns=\"http://tempuri.org/\">\n      <strCodAgeCargo>test</strCodAgeCargo>\n      <strCodAgeOri>test</strCodAgeOri>\n      <dtFecha>#{Date.tomorrow.strftime('%Y/%m/%d')}</dtFecha>\n      <strCodTipoServ>72</strCodTipoServ>\n      <strCodCli>1004</strCodCli>\n      <strNomOri>Sender name</strNomOri>\n      <strDirOri>Sender street</strDirOri>\n      <strCPOri>48950</strCPOri>\n      <strTlfOri>666666666</strTlfOri>\n      <strNomDes>Receiver name</strNomDes>\n      <strDirDes>Receiver street</strDirDes>\n      <strCPDes>48950</strCPDes>\n      <strTlfDes>666666666</strTlfDes>\n      <intDoc>0</intDoc>\n      <intPaq>1</intPaq>\n      <dPesoOri>0</dPesoOri>\n      <dAltoOri>0</dAltoOri>\n      <dAnchoOri>0</dAnchoOri>\n      <dLargoOri>0</dLargoOri>\n      <dReembolso>0</dReembolso>\n      <dValor>0</dValor>\n      <dAnticipo>0</dAnticipo>\n      <dCobCli>0</dCobCli>\n      <strObs></strObs>\n      <boSabado>false</boSabado>\n      <boRetorno>false</boRetorno>\n      <boGestOri>false</boGestOri>\n      <boGestDes>false</boGestDes>\n      <boAnulado>false</boAnulado>\n      <boAcuse>false</boAcuse>\n      <strRef>shipmentX</strRef>\n      <dBaseImp>0</dBaseImp>\n      <dImpuesto>0</dImpuesto>\n      <boPorteDebCli>false</boPorteDebCli>\n      <strDesDirEmails>receiver@example.com</strDesDirEmails>\n      <boInsert>true</boInsert>\n      <boCampo5>false</boCampo5>\n      <boPagoDUAImp>false</boPagoDUAImp>\n      <boPagoImpDes>false</boPagoImpDes>\n    </WebServService___GrabaEnvio8>\n  </soap:Body>\n</soap:Envelope>\n",
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

  # Error
  # ---

  stub_request(:post, "http://wstest.envialia.com:9085/SOAP?service=WebServService").
    with(
      body: "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">\n  <soap:Header>\n    <ROClientIDHeader xmlns=\"http://tempuri.org/\">\n      <ID>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</ID>\n    </ROClientIDHeader>\n  </soap:Header>\n  <soap:Body>\n    <WebServService___GrabaEnvio8 xmlns=\"http://tempuri.org/\">\n      <strCodAgeCargo>test</strCodAgeCargo>\n      <strCodAgeOri>test</strCodAgeOri>\n      <dtFecha>#{Date.tomorrow.strftime('%Y/%m/%d')}</dtFecha>\n      <strCodTipoServ>72</strCodTipoServ>\n      <strCodCli>1004</strCodCli>\n      <strNomOri>Sender name</strNomOri>\n      <strDirOri>Sender street</strDirOri>\n      <strCPOri></strCPOri>\n      <strTlfOri>666666666</strTlfOri>\n      <strNomDes>Receiver name</strNomDes>\n      <strDirDes>Receiver street</strDirDes>\n      <strCPDes>48950</strCPDes>\n      <strTlfDes>666666666</strTlfDes>\n      <intDoc>0</intDoc>\n      <intPaq>1</intPaq>\n      <dPesoOri>0</dPesoOri>\n      <dAltoOri>0</dAltoOri>\n      <dAnchoOri>0</dAnchoOri>\n      <dLargoOri>0</dLargoOri>\n      <dReembolso>0</dReembolso>\n      <dValor>0</dValor>\n      <dAnticipo>0</dAnticipo>\n      <dCobCli>0</dCobCli>\n      <strObs></strObs>\n      <boSabado>false</boSabado>\n      <boRetorno>false</boRetorno>\n      <boGestOri>false</boGestOri>\n      <boGestDes>false</boGestDes>\n      <boAnulado>false</boAnulado>\n      <boAcuse>false</boAcuse>\n      <strRef>shipmentX</strRef>\n      <dBaseImp>0</dBaseImp>\n      <dImpuesto>0</dImpuesto>\n      <boPorteDebCli>false</boPorteDebCli>\n      <strDesDirEmails>receiver@example.com</strDesDirEmails>\n      <boInsert>true</boInsert>\n      <boCampo5>false</boCampo5>\n      <boPagoDUAImp>false</boPagoDUAImp>\n      <boPagoImpDes>false</boPagoImpDes>\n    </WebServService___GrabaEnvio8>\n  </soap:Body>\n</soap:Envelope>\n",
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
          xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
          <SOAP-ENV:Header>
            <ROClientIDHeader SOAP-ENV:mustUnderstand="0"
              xmlns="http://tempuri.org/">
              <ID>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</ID>
            </ROClientIDHeader>
          </SOAP-ENV:Header>
          <SOAP-ENV:Body
            xmlns:ro="http://tempuri.org/">
            <SOAP-ENV:Fault>
              <faultcode>Exception</faultcode>
              <faultstring>41: El código postal origen es nulo o no válido</faultstring>
            </SOAP-ENV:Fault>
          </SOAP-ENV:Body>
          </SOAP-ENV:Envelope>
      XML
      headers: {}
    )
end

def register_envialia_create_pickup_stubs
  login_request

  # Success
  # ---

  stub_request(:post, "http://wstest.envialia.com:9085/SOAP?service=WebServService").
    with(
      body: "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">\n  <soap:Header>\n  <ROClientIDHeader xmlns=\"http://tempuri.org/\">\n    <ID>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</ID>\n  </ROClientIDHeader>\n  </soap:Header>\n  <soap:Body>\n  <WebServService___GrabaRecogida3 xmlns=\"http://tempuri.org/\">\n    <strCod></strCod>\n    <strAlbaran>0128346910</strAlbaran>\n    <strCodAgeCargo>test</strCodAgeCargo>\n    <strCodAgeOri></strCodAgeOri>\n    <dtFecRec>#{Date.tomorrow.strftime('%Y/%m/%d')}</dtFecRec>\n    <strNomOri>Sender name</strNomOri>\n    <strDirOri>Sender street</strDirOri>\n    <strCPOri>48950</strCPOri>\n    <strTlfOri>666666666</strTlfOri>\n    <strNomDes>Receiver name</strNomDes>\n    <strDirDes>Receiver street</strDirDes>\n    <strCPDes>48950</strCPDes>\n    <strTlfDes>666666666</strTlfDes>\n    <intBul>1</intBul>\n    <dPesoOri>0</dPesoOri>\n    <dAltoOri>0</dAltoOri>\n    <dAnchoOri>0</dAnchoOri>\n    <dLargoOri>0</dLargoOri>\n    <dReembolso>0</dReembolso>\n    <dValor>0</dValor>\n    <dAnticipo>0</dAnticipo>\n    <dCobCli>0</dCobCli>\n    <strObs></strObs>\n    <boSabado>false</boSabado>\n    <boRetorno>false</boRetorno>\n    <boGestOri>false</boGestOri>\n    <boGestDes>false</boGestDes>\n    <boAnulado>false</boAnulado>\n    <boAcuse>false</boAcuse>\n    <strRef>shipmentX</strRef>\n    <dBaseImp>0</dBaseImp>\n    <dImpuesto>0</dImpuesto>\n    <boPorteDebCli>false</boPorteDebCli>\n    <strDesDirEmails>receiver@example.com</strDesDirEmails>\n    <boCampo5>false</boCampo5>\n    <boPagoDUAImp>false</boPagoDUAImp>\n    <boPagoImpDes>false</boPagoImpDes>\n  </WebServService___GrabaRecogida3>\n  </soap:Body>\n  </soap:Envelope>\n",
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
              <v1:strCodOut>0128346910</v1:strCodOut>
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

  # Error
  # ---

  stub_request(:post, "http://wstest.envialia.com:9085/SOAP?service=WebServService").
    with(
      body: "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">\n  <soap:Header>\n  <ROClientIDHeader xmlns=\"http://tempuri.org/\">\n    <ID>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</ID>\n  </ROClientIDHeader>\n  </soap:Header>\n  <soap:Body>\n  <WebServService___GrabaRecogida3 xmlns=\"http://tempuri.org/\">\n    <strCod></strCod>\n    <strAlbaran></strAlbaran>\n    <strCodAgeCargo>test</strCodAgeCargo>\n    <strCodAgeOri></strCodAgeOri>\n    <dtFecRec>2021/11/19</dtFecRec>\n    <strNomOri>Sender name</strNomOri>\n    <strDirOri>Sender street</strDirOri>\n    <strCPOri></strCPOri>\n    <strTlfOri>666666666</strTlfOri>\n    <strNomDes>Receiver name</strNomDes>\n    <strDirDes>Receiver street</strDirDes>\n    <strCPDes>48950</strCPDes>\n    <strTlfDes>666666666</strTlfDes>\n    <intBul>1</intBul>\n    <dPesoOri>0</dPesoOri>\n    <dAltoOri>0</dAltoOri>\n    <dAnchoOri>0</dAnchoOri>\n    <dLargoOri>0</dLargoOri>\n    <dReembolso>0</dReembolso>\n    <dValor>0</dValor>\n    <dAnticipo>0</dAnticipo>\n    <dCobCli>0</dCobCli>\n    <strObs></strObs>\n    <boSabado>false</boSabado>\n    <boRetorno>false</boRetorno>\n    <boGestOri>false</boGestOri>\n    <boGestDes>false</boGestDes>\n    <boAnulado>false</boAnulado>\n    <boAcuse>false</boAcuse>\n    <strRef>shipmentX</strRef>\n    <dBaseImp>0</dBaseImp>\n    <dImpuesto>0</dImpuesto>\n    <boPorteDebCli>false</boPorteDebCli>\n    <strDesDirEmails>receiver@example.com</strDesDirEmails>\n    <boCampo5>false</boCampo5>\n    <boPagoDUAImp>false</boPagoDUAImp>\n    <boPagoImpDes>false</boPagoImpDes>\n  </WebServService___GrabaRecogida3>\n  </soap:Body>\n  </soap:Envelope>\n",
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
          xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
          <SOAP-ENV:Header>
            <ROClientIDHeader SOAP-ENV:mustUnderstand="0"
              xmlns="http://tempuri.org/">
              <ID>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</ID>
            </ROClientIDHeader>
          </SOAP-ENV:Header>
          <SOAP-ENV:Body
            xmlns:ro="http://tempuri.org/">
            <SOAP-ENV:Fault>
              <faultcode>Exception</faultcode>
              <faultstring>7: La agencia de origen no existe o está inactiva</faultstring>
            </SOAP-ENV:Fault>
          </SOAP-ENV:Body>
        </SOAP-ENV:Envelope>
      XML
      headers: {}
    )
end

def register_envialia_shipment_info_stubs
  login_request

  # Success
  # ---

  stub_request(:post, "http://wstest.envialia.com:9085/SOAP?service=WebServService").
    with(
      body: "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\">\n  <soapenv:Header>\n    <tns:ROClientIDHeader xmlns:tns=\"http://tempuri.org/\">\n      <tns:ID>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</tns:ID>\n    </tns:ROClientIDHeader>\n  </soapenv:Header>\n  <soapenv:Body>\n    <tns:WebServService___ConsEnvEstados xmlns:tns=\"http://tempuri.org/\"><!-- mandatory -->\n      <tns:strCodAgeCargo>test</tns:strCodAgeCargo>\n      <tns:strCodAgeOri>test</tns:strCodAgeOri>\n      <tns:strAlbaran>E001</tns:strAlbaran>\n    </tns:WebServService___ConsEnvEstados>\n  </soapenv:Body>\n</soapenv:Envelope>\n",
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
            <v1:WebServService___ConsEnvEstadosResponse>
              <v1:strEnvEstados>&lt;CONSULTA&gt;&lt;ENV_ESTADOS
                I_ID="1"
                V_COD_TIPO_EST="0"
                D_FEC_HORA_ALTA="11/11/2021 12:44:14"
                V_COD_USU_ALTA=""
                V_COD_AGE_ALTA="002800"
                V_COD_REP_ALTA=""
                V_COD_CLI_ALTA="WS101"
                V_COD_CLI_DEP_ALTA=""
                V_CAMPO_1=""
                V_CAMPO_2=""
                V_CAMPO_3=""
                V_CAMPO_4=""
                B_CAMPO_5="False"/&gt;&lt;/CONSULTA&gt;
              </v1:strEnvEstados>
            </v1:WebServService___ConsEnvEstadosResponse>
          </SOAP-ENV:Body>
        </SOAP-ENV:Envelope>
      XML
      headers: {}
    )

  # Error
  # ---

  stub_request(:post, "http://wstest.envialia.com:9085/SOAP?service=WebServService").
    with(
      body: "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\">\n  <soapenv:Header>\n    <tns:ROClientIDHeader xmlns:tns=\"http://tempuri.org/\">\n      <tns:ID>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</tns:ID>\n    </tns:ROClientIDHeader>\n  </soapenv:Header>\n  <soapenv:Body>\n    <tns:WebServService___ConsEnvEstados xmlns:tns=\"http://tempuri.org/\"><!-- mandatory -->\n      <tns:strCodAgeCargo>test</tns:strCodAgeCargo>\n      <tns:strCodAgeOri>test</tns:strCodAgeOri>\n      <tns:strAlbaran>E000</tns:strAlbaran>\n    </tns:WebServService___ConsEnvEstados>\n  </soapenv:Body>\n</soapenv:Envelope>\n",
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
              <ID>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161</ID>
            </ROClientIDHeader>
          </SOAP-ENV:Header>
          <SOAP-ENV:Body
            xmlns:ro="http://tempuri.org/">
            <v1:WebServService___ConsEnvio2Response>
              <v1:strEnvio></v1:strEnvio>
            </v1:WebServService___ConsEnvio2Response>
          </SOAP-ENV:Body>
        </SOAP-ENV:Envelope>
      XML
      headers: {}
    )
end

def register_envialia_pickup_info_stubs
  login_request

  # Success
  # ---

  stub_request(:post, "http://wstest.envialia.com:9085/SOAP?service=WebServService").
    with(
      body: "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\">\n  <soapenv:Header>\n    <tns:ROClientIDHeader xmlns:tns=\"http://tempuri.org/\">\n      <tns:ID>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</tns:ID>\n    </tns:ROClientIDHeader>\n  </soapenv:Header>\n  <soapenv:Body>\n    <tns:WebServService___ConsRecEstados xmlns:tns=\"http://tempuri.org/\">\n      <tns:strCodRec>E001</tns:strCodRec>\n    </tns:WebServService___ConsRecEstados>\n  </soapenv:Body>\n</soapenv:Envelope>\n",
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
            <v1:WebServService___ConsRecEstadosResponse>
              <v1:strRecEstados>&lt;CONSULTA&gt;&lt;REC_ESTADOS
                I_ID="1"
                V_COD_TIPO_EST="R0"
                D_FEC_HORA_ALTA="11/11/2021 12:44:14"
                V_COD_USU_ALTA=""
                V_COD_AGE_ALTA="002800"
                V_COD_REP_ALTA=""
                V_COD_CLI_ALTA="WS101"
                V_COD_CLI_DEP_ALTA=""
                V_CAMPO_1=""
                V_CAMPO_2=""
                V_CAMPO_3=""
                V_CAMPO_4=""
                B_CAMPO_5="False"/&gt;&lt;/CONSULTA&gt;
              </v1:strRecEstados>
            </v1:WebServService___ConsRecEstadosResponse>
          </SOAP-ENV:Body>
        </SOAP-ENV:Envelope>
      XML
      headers: {}
    )

  # Error
  # ---

  stub_request(:post, "http://wstest.envialia.com:9085/SOAP?service=WebServService").
    with(
      body: "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\">\n  <soapenv:Header>\n    <tns:ROClientIDHeader xmlns:tns=\"http://tempuri.org/\">\n      <tns:ID>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</tns:ID>\n    </tns:ROClientIDHeader>\n  </soapenv:Header>\n  <soapenv:Body>\n    <tns:WebServService___ConsRecEstados xmlns:tns=\"http://tempuri.org/\">\n      <tns:strCodRec>E000</tns:strCodRec>\n    </tns:WebServService___ConsRecEstados>\n  </soapenv:Body>\n</soapenv:Envelope>\n",
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
            <v1:WebServService___ConsRecEstadosResponse>
              <v1:strRecEstados></v1:strRecEstados>
            </v1:WebServService___ConsRecEstadosResponse>
          </SOAP-ENV:Body>
        </SOAP-ENV:Envelope>
      XML
      headers: {}
    )
end

def register_envialia_get_label_stubs
  login_request

  stub_request(:post, "http://wstest.envialia.com:9085/SOAP?service=WebServService").
    with(
      body: "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<soap:Envelope\n  xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"\n  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n  xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">\n  <soap:Header>\n    <ROClientIDHeader xmlns=\"http://tempuri.org/\">\n      <ID>{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}</ID>\n    </ROClientIDHeader>\n  </soap:Header>\n  <soap:Body>\n    <WebServService___ConsEtiquetaEnvio6>\n      <strCodAgeOri>test</strCodAgeOri>\n      <strAlbaran>E001</strAlbaran>\n      <strBulto></strBulto>\n      <boPaginaA4>false</boPaginaA4>\n      <intNumEtiqImpresasA4>0</intNumEtiqImpresasA4>\n      <strFormato>PDF</strFormato>\n    </WebServService___ConsEtiquetaEnvio6>\n  </soap:Body>\n</soap:Envelope>\n",
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
            <v1:WebServService___ConsEtiquetaEnvio6Response>
              <v1:strEtiquetas>JVBERi0xLjUNCiXi48/TDQoxIDAgb2JqDQo8PA0KL1R5cGUgL0NhdGFsb2cNCi9QYWdlcyAzIDAgUg0KL1BhZ2VNb2RlIC9Vc2VOb25lDQovVmlld2VyUHJlZmVyZW5jZXMgPDwNCi9QcmludFNjYWxpbmcgL05vbmUNCj4+DQo+Pg0KZW5kb2JqDQoyIDAgb2JqDQo8PA0KL1RpdGxlIDxGRUZGPg0KL0F1dGhvciA8RkVGRjAwNDYwMDYxMDA3MzAwNzQwMDUyMDA2NTAwNzAwMDZGMDA3MjAwNzQ+DQovU3ViamVjdCA8RkVGRjAwNDYwMDYxMDA3MzAwNzQwMDUyMDA2NTAwNzAwMDZGMDA3MjAwNzQwMDIwMDA1MDAwNDQwMDQ2MDAyMDAwNjUwMDc4MDA3MDAwNkYwMDcyMDA3ND4NCi9LZXl3b3JkcyA8RkVGRj4NCi9DcmVhdG9yIDxGRUZGPg0KL1Byb2R1Y2VyIDxGRUZGPg0KL0NyZWF0aW9uRGF0ZSAoRDoyMDIxMTExNjA0MTEzMSkNCi9Nb2REYXRlIChEOjIwMjExMTE2MDQxMTMxKQ0KPj4NCmVuZG9iag0KNCAwIG9iag0KPDwNCi9UeXBlIC9Gb250DQovTmFtZSAvRjANCi9CYXNlRm9udCAvQXJpYWwNCi9TdWJ0eXBlIC9UcnVlVHlwZQ0KL0VuY29kaW5nIC9XaW5BbnNpRW5jb2RpbmcNCi9Gb250RGVzY3JpcHRvciA1IDAgUg0KL0ZpcnN0Q2hhciAzMA0KL0xhc3RDaGFyIDI1NQ0KL1dpZHRocyBbNzUwIDc1MCAyNzggMjc4IDM1NSA1NTYgNTU2IDg4OSA2NjcgMTkxIDMzMyAzMzMgMzg5IDU4NCAyNzggMzMzIDI3OCAyNzggNTU2IDU1NiA1NTYgNTU2IDU1NiA1NTYgNTU2IDU1NiA1NTYgNTU2IDI3OCAyNzggNTg0IDU4NCA1ODQgNTU2IDEwMTUgNjY3IDY2NyA3MjIgNzIyIDY2NyA2MTEgNzc4IDcyMiAyNzggNTAwIDY2NyA1NTYgODMzIDcyMiA3NzggNjY3IDc3OCA3MjIgNjY3IDYxMSA3MjIgNjY3IDk0NCA2NjcgNjY3IDYxMSAyNzggMjc4IDI3OCA0NjkgNTU2IDMzMyA1NTYgNTU2IDUwMCA1NTYgNTU2IDI3OCA1NTYgNTU2IDIyMiAyMjIgNTAwIDIyMiA4MzMgNTU2IDU1NiA1NTYgNTU2IDMzMyA1MDAgMjc4IDU1NiA1MDAgNzIyIDUwMCA1MDAgNTAwIDMzNCAyNjAgMzM0IDU4NCA3NTAgNTU2IDc1MCAyMjIgNTU2IDMzMyAxMDAwIDU1NiA1NTYgMzMzIDEwMDAgNjY3IDMzMyAxMDAwIDc1MCA2MTEgNzUwIDc1MCAyMjIgMjIyIDMzMyAzMzMgMzUwIDU1NiAxMDAwIDMzMyAxMDAwIDUwMCAzMzMgOTQ0IDc1MCA1MDAgNjY3IDI3OCAzMzMgNTU2IDU1NiA1NTYgNTU2IDI2MCA1NTYgMzMzIDczNyAzNzAgNTU2IDU4NCAzMzMgNzM3IDU1MiA0MDAgNTQ5IDMzMyAzMzMgMzMzIDU3NiA1MzcgMzMzIDMzMyAzMzMgMzY1IDU1NiA4MzQgODM0IDgzNCA2MTEgNjY3IDY2NyA2NjcgNjY3IDY2NyA2NjcgMTAwMCA3MjIgNjY3IDY2NyA2NjcgNjY3IDI3OCAyNzggMjc4IDI3OCA3MjIgNzIyIDc3OCA3NzggNzc4IDc3OCA3NzggNTg0IDc3OCA3MjIgNzIyIDcyMiA3MjIgNjY3IDY2NyA2MTEgNTU2IDU1NiA1NTYgNTU2IDU1NiA1NTYgODg5IDUwMCA1NTYgNTU2IDU1NiA1NTYgMjc4IDI3OCAyNzggMjc4IDU1NiA1NTYgNTU2IDU1NiA1NTYgNTU2IDU1NiA1NDkgNjExIDU1NiA1NTYgNTU2IDU1NiA1MDAgNTU2IDUwMCBdDQo+Pg0KZW5kb2JqDQo1IDAgb2JqDQo8PA0KL1R5cGUgL0ZvbnREZXNjcmlwdG9yDQovRm9udE5hbWUgL0FyaWFsDQovRmxhZ3MgMzINCi9Gb250QkJveCBbLTY2NSAtMzI1IDIwMDAgMTA0MCBdDQovSXRhbGljQW5nbGUgMA0KL0FzY2VudCA3MjgNCi9EZXNjZW50IC0yMTANCi9MZWFkaW5nIDExNw0KL0NhcEhlaWdodCAxMTE3DQovU3RlbVYgODgNCi9BdmdXaWR0aCA0NDENCi9NYXhXaWR0aCAyNjY1DQovTWlzc2luZ1dpZHRoIDQ0MQ0KPj4NCmVuZG9iag0KNiAwIG9iag0KPDwNCi9UeXBlIC9Gb250DQovTmFtZSAvRjENCi9CYXNlRm9udCAvQXJpYWwsQm9sZA0KL1N1YnR5cGUgL1RydWVUeXBlDQovRW5jb2RpbmcgL1dpbkFuc2lFbmNvZGluZw0KL0ZvbnREZXNjcmlwdG9yIDcgMCBSDQovRmlyc3RDaGFyIDMwDQovTGFzdENoYXIgMjU1DQovV2lkdGhzIFs3NTAgNzUwIDI3OCAzMzMgNDc0IDU1NiA1NTYgODg5IDcyMiAyMzggMzMzIDMzMyAzODkgNTg0IDI3OCAzMzMgMjc4IDI3OCA1NTYgNTU2IDU1NiA1NTYgNTU2IDU1NiA1NTYgNTU2IDU1NiA1NTYgMzMzIDMzMyA1ODQgNTg0IDU4NCA2MTEgOTc1IDcyMiA3MjIgNzIyIDcyMiA2NjcgNjExIDc3OCA3MjIgMjc4IDU1NiA3MjIgNjExIDgzMyA3MjIgNzc4IDY2NyA3NzggNzIyIDY2NyA2MTEgNzIyIDY2NyA5NDQgNjY3IDY2NyA2MTEgMzMzIDI3OCAzMzMgNTg0IDU1NiAzMzMgNTU2IDYxMSA1NTYgNjExIDU1NiAzMzMgNjExIDYxMSAyNzggMjc4IDU1NiAyNzggODg5IDYxMSA2MTEgNjExIDYxMSAzODkgNTU2IDMzMyA2MTEgNTU2IDc3OCA1NTYgNTU2IDUwMCAzODkgMjgwIDM4OSA1ODQgNzUwIDU1NiA3NTAgMjc4IDU1NiA1MDAgMTAwMCA1NTYgNTU2IDMzMyAxMDAwIDY2NyAzMzMgMTAwMCA3NTAgNjExIDc1MCA3NTAgMjc4IDI3OCA1MDAgNTAwIDM1MCA1NTYgMTAwMCAzMzMgMTAwMCA1NTYgMzMzIDk0NCA3NTAgNTAwIDY2NyAyNzggMzMzIDU1NiA1NTYgNTU2IDU1NiAyODAgNTU2IDMzMyA3MzcgMzcwIDU1NiA1ODQgMzMzIDczNyA1NTIgNDAwIDU0OSAzMzMgMzMzIDMzMyA1NzYgNTU2IDMzMyAzMzMgMzMzIDM2NSA1NTYgODM0IDgzNCA4MzQgNjExIDcyMiA3MjIgNzIyIDcyMiA3MjIgNzIyIDEwMDAgNzIyIDY2NyA2NjcgNjY3IDY2NyAyNzggMjc4IDI3OCAyNzggNzIyIDcyMiA3NzggNzc4IDc3OCA3NzggNzc4IDU4NCA3NzggNzIyIDcyMiA3MjIgNzIyIDY2NyA2NjcgNjExIDU1NiA1NTYgNTU2IDU1NiA1NTYgNTU2IDg4OSA1NTYgNTU2IDU1NiA1NTYgNTU2IDI3OCAyNzggMjc4IDI3OCA2MTEgNjExIDYxMSA2MTEgNjExIDYxMSA2MTEgNTQ5IDYxMSA2MTEgNjExIDYxMSA2MTEgNTU2IDYxMSA1NTYgXQ0KPj4NCmVuZG9iag0KNyAwIG9iag0KPDwNCi9UeXBlIC9Gb250RGVzY3JpcHRvcg0KL0ZvbnROYW1lIC9BcmlhbCxCb2xkDQovRmxhZ3MgMzINCi9Gb250QkJveCBbLTYyOCAtMzc2IDIwMDAgMTA1NiBdDQovSXRhbGljQW5nbGUgMA0KL0FzY2VudCA3MjgNCi9EZXNjZW50IC0yMTANCi9MZWFkaW5nIDExNw0KL0NhcEhlaWdodCAxMTE3DQovU3RlbVYgMTY2DQovQXZnV2lkdGggNDc5DQovTWF4V2lkdGggMjYyOA0KL01pc3NpbmdXaWR0aCA0NzkNCj4+DQplbmRvYmoNCjggMCBvYmoNCjw8DQovVHlwZSAvRm9udA0KL05hbWUgL0YyDQovQmFzZUZvbnQgL0FyaWFsLEJvbGQNCi9TdWJ0eXBlIC9UcnVlVHlwZQ0KL0VuY29kaW5nIC9XaW5BbnNpRW5jb2RpbmcNCi9Gb250RGVzY3JpcHRvciA5IDAgUg0KL0ZpcnN0Q2hhciAzMA0KL0xhc3RDaGFyIDI1NQ0KL1dpZHRocyBbNzUwIDc1MCAyNzggMzMzIDQ3NCA1NTYgNTU2IDg4OSA3MjIgMjM4IDMzMyAzMzMgMzg5IDU4NCAyNzggMzMzIDI3OCAyNzggNTU2IDU1NiA1NTYgNTU2IDU1NiA1NTYgNTU2IDU1NiA1NTYgNTU2IDMzMyAzMzMgNTg0IDU4NCA1ODQgNjExIDk3NSA3MjIgNzIyIDcyMiA3MjIgNjY3IDYxMSA3NzggNzIyIDI3OCA1NTYgNzIyIDYxMSA4MzMgNzIyIDc3OCA2NjcgNzc4IDcyMiA2NjcgNjExIDcyMiA2NjcgOTQ0IDY2NyA2NjcgNjExIDMzMyAyNzggMzMzIDU4NCA1NTYgMzMzIDU1NiA2MTEgNTU2IDYxMSA1NTYgMzMzIDYxMSA2MTEgMjc4IDI3OCA1NTYgMjc4IDg4OSA2MTEgNjExIDYxMSA2MTEgMzg5IDU1NiAzMzMgNjExIDU1NiA3NzggNTU2IDU1NiA1MDAgMzg5IDI4MCAzODkgNTg0IDc1MCA1NTYgNzUwIDI3OCA1NTYgNTAwIDEwMDAgNTU2IDU1NiAzMzMgMTAwMCA2NjcgMzMzIDEwMDAgNzUwIDYxMSA3NTAgNzUwIDI3OCAyNzggNTAwIDUwMCAzNTAgNTU2IDEwMDAgMzMzIDEwMDAgNTU2IDMzMyA5NDQgNzUwIDUwMCA2NjcgMjc4IDMzMyA1NTYgNTU2IDU1NiA1NTYgMjgwIDU1NiAzMzMgNzM3IDM3MCA1NTYgNTg0IDMzMyA3MzcgNTUyIDQwMCA1NDkgMzMzIDMzMyAzMzMgNTc2IDU1NiAzMzMgMzMzIDMzMyAzNjUgNTU2IDgzNCA4MzQgODM0IDYxMSA3MjIgNzIyIDcyMiA3MjIgNzIyIDcyMiAxMDAwIDcyMiA2NjcgNjY3IDY2NyA2NjcgMjc4IDI3OCAyNzggMjc4IDcyMiA3MjIgNzc4IDc3OCA3NzggNzc4IDc3OCA1ODQgNzc4IDcyMiA3MjIgNzIyIDcyMiA2NjcgNjY3IDYxMSA1NTYgNTU2IDU1NiA1NTYgNTU2IDU1NiA4ODkgNTU2IDU1NiA1NTYgNTU2IDU1NiAyNzggMjc4IDI3OCAyNzggNjExIDYxMSA2MTEgNjExIDYxMSA2MTEgNjExIDU0OSA2MTEgNjExIDYxMSA2MTEgNjExIDU1NiA2MTEgNTU2IF0NCj4+DQplbmRvYmoNCjkgMCBvYmoNCjw8DQovVHlwZSAvRm9udERlc2NyaXB0b3INCi9Gb250TmFtZSAvQXJpYWwsQm9sZA0KL0ZsYWdzIDMyDQovRm9udEJCb3ggWy02MjggLTM3NiAyMDAwIDEwNTYgXQ0KL0l0YWxpY0FuZ2xlIDANCi9Bc2NlbnQgNzI4DQovRGVzY2VudCAtMjEwDQovTGVhZGluZyAxMTcNCi9DYXBIZWlnaHQgMTExNw0KL1N0ZW1WIDE2Ng0KL0F2Z1dpZHRoIDQ3OQ0KL01heFdpZHRoIDI2MjgNCi9NaXNzaW5nV2lkdGggNDc5DQo+Pg0KZW5kb2JqDQoxMCAwIG9iag0KPDwNCi9UeXBlIC9Gb250DQovTmFtZSAvRjMNCi9CYXNlRm9udCAvQXJpYWwNCi9TdWJ0eXBlIC9UcnVlVHlwZQ0KL0VuY29kaW5nIC9XaW5BbnNpRW5jb2RpbmcNCi9Gb250RGVzY3JpcHRvciAxMSAwIFINCi9GaXJzdENoYXIgMzANCi9MYXN0Q2hhciAyNTUNCi9XaWR0aHMgWzc1MCA3NTAgMjc4IDI3OCAzNTUgNTU2IDU1NiA4ODkgNjY3IDE5MSAzMzMgMzMzIDM4OSA1ODQgMjc4IDMzMyAyNzggMjc4IDU1NiA1NTYgNTU2IDU1NiA1NTYgNTU2IDU1NiA1NTYgNTU2IDU1NiAyNzggMjc4IDU4NCA1ODQgNTg0IDU1NiAxMDE1IDY2NyA2NjcgNzIyIDcyMiA2NjcgNjExIDc3OCA3MjIgMjc4IDUwMCA2NjcgNTU2IDgzMyA3MjIgNzc4IDY2NyA3NzggNzIyIDY2NyA2MTEgNzIyIDY2NyA5NDQgNjY3IDY2NyA2MTEgMjc4IDI3OCAyNzggNDY5IDU1NiAzMzMgNTU2IDU1NiA1MDAgNTU2IDU1NiAyNzggNTU2IDU1NiAyMjIgMjIyIDUwMCAyMjIgODMzIDU1NiA1NTYgNTU2IDU1NiAzMzMgNTAwIDI3OCA1NTYgNTAwIDcyMiA1MDAgNTAwIDUwMCAzMzQgMjYwIDMzNCA1ODQgNzUwIDU1NiA3NTAgMjIyIDU1NiAzMzMgMTAwMCA1NTYgNTU2IDMzMyAxMDAwIDY2NyAzMzMgMTAwMCA3NTAgNjExIDc1MCA3NTAgMjIyIDIyMiAzMzMgMzMzIDM1MCA1NTYgMTAwMCAzMzMgMTAwMCA1MDAgMzMzIDk0NCA3NTAgNTAwIDY2NyAyNzggMzMzIDU1NiA1NTYgNTU2IDU1NiAyNjAgNTU2IDMzMyA3MzcgMzcwIDU1NiA1ODQgMzMzIDczNyA1NTIgNDAwIDU0OSAzMzMgMzMzIDMzMyA1NzYgNTM3IDMzMyAzMzMgMzMzIDM2NSA1NTYgODM0IDgzNCA4MzQgNjExIDY2NyA2NjcgNjY3IDY2NyA2NjcgNjY3IDEwMDAgNzIyIDY2NyA2NjcgNjY3IDY2NyAyNzggMjc4IDI3OCAyNzggNzIyIDcyMiA3NzggNzc4IDc3OCA3NzggNzc4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</v1:strEtiquetas>
            </v1:WebServService___ConsEtiquetaEnvio6Response>
          </SOAP-ENV:Body>
          </SOAP-ENV:Envelope>

      XML
      headers: {}
    )
end

def login_request
  # Stub login request
  allow_any_instance_of(Deliveries::Couriers::Envialia::Authentication).to receive(:session_id).and_return(
    "{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}"
  )
end
