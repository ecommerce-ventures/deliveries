def register_envialia_login_stubs
  # Success
  # ---

  stub_request(:post, "http://wstest.envialia.com:9085/SOAP?service=LoginService").
    with(
      body: "<?xml version='1.0' encoding='utf-8'?>\n          <soap:Envelope\n            xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'\n            xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'\n            xmlns:xsd='http://www.w3.org/2001/XMLSchema'>\n            <soap:Body>\n              <LoginWSService___LoginCli2>\n              <strCodAge>test</strCodAge>\n              <strCliente>test</strCliente>\n              <strPass>test</strPass>\n              </LoginWSService___LoginCli2>\n            </soap:Body>\n        </soap:Envelope>",
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
  stub_request(:post, "http://wstest.envialia.com:9085/SOAP?service=WebServService").
    with(
      body: <<~XML,
      <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 			xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <soap:Header>
          <ROClientIDHeader xmlns="http://tempuri.org/">
            <ID>{1D8A0F8B-ABB7-41C9-9860-D794F061A642}</ID>
          </ROClientIDHeader>
        </soap:Header>
        <soap:Body>
          <WebServService___GrabaEnvio8 xmlns="http://tempuri.org/">
          <strCodAgeCargo>test</strCodAgeCargo>
          <strCodAgeOri>test</strCodAgeOri>
          <strAlbaran>test</strAlbaran>
          <dtFecha>2021/10/28</dtFecha>
          <strCodAgeDes>test</strCodAgeDes>
          <strCodTipoServ>test</strCodTipoServ>
          <strCodCli>test</strCodCli>
          <strCodCliDep>test</strCodCliDep>
          <strNomOri>test</strNomOri>
          <strTipoViaOri>--tipo-via-remitente--</strTipoViaOri>
          <strDirOri>--nombre-via-remitente--</strDirOri>
          <strNumOri>--numero-casa--</strNumOri>
          <strPisoOri>--piso-remitente--</strPisoOri>
          <strPobOri>--poblacion-remitente--</strPobOri>
          <strCPOri>--C.P.-remitente--</strCPOri>
          <strCodProOri>--cod-provincia-remitente--</strCodProOri>
          <strTlfOri>--telefono-remitente--</strTlfOri>
          <strNomDes>--nombre-destinatario--</strNomDes>
          <strTipoViaDes>--tipo-via-destinatario--</strTipoViaDes>
          <strDirDes>--nombre-via-destinatario--</strDirDes>
          <strNumDes>--numero-casa-dest--</strNumDes>
          <strPisoDes>--piso-destinatario--</strPisoDes>
          <strPobDes>--poblacion-dest--</strPobDes>
          <strCPDes>--C.P. Dest--</strCPDes>
          <strCodProDes>--cod-provincia-dest--</strCodProDes>
          <strTlfDes>--telefono-des--</strTlfDes>
          <intDoc>1</intDoc>
          <intPaq>1</intPaq>
          <dPesoOri>1</dPesoOri>
          <dAltoOri>1</dAltoOri>
          <dAnchoOri>1</dAnchoOri>
          <dLargoOri>1</dLargoOri>
          <dReembolso>0</dReembolso>
          <dValor>100</dValor>
          <dAnticipo>1</dAnticipo>
          <dCobCli>100</dCobCli>
          <strObs>test</strObs>
          <boSabado>0</boSabado>
          <boRetorno>0</boRetorno>
          <boGestOri>0</boGestOri>
          <boGestDes>0</boGestDes>
          <boAnulado>0</boAnulado>
          <boAcuse>0</boAcuse>
          <strRef>12345</strRef>
          <strCodSalRuta>--codigo-sal-ruta--</strCodSalRuta>
          <dBaseImp>1</dBaseImp>
          <dImpuesto>0</dImpuesto>
          <boPorteDebCli>0</boPorteDebCli>
          <strPersContacto>test</strPersContacto>
          <strCodPais>ES-</strCodPais>
          <strDesMoviles>--moviles-destinatario--</strDesMoviles>
          <strDesDirEmails>--emails-destinatario--</strDesDirEmails>
          <strFranjaHoraria>--franja-horaria--</strFranjaHoraria>
          <dtHoraEnvIni>2021/10/28 20:51:23</dtHoraEnvIni>
          <dtHoraEnvFin>2021/10/28 20:51:23</dtHoraEnvFin>
          <boInsert>0</boInsert>
          <strCampo1>--campo-personalizable-1--</strCampo1>
          <strCampo2>--campo-personalizable-2--</strCampo2>
          <strCampo3>--campo-personalizable-3--</strCampo3>
          <strCampo4>--campo-personalizable-4--</strCampo4>
          <boCampo5>0</boCampo5>
          <boPagoDUAImp>0</boPagoDUAImp>
          <boPagoImpDes>0</boPagoImpDes>
          </WebServService___GrabaEnvio8>
        </soap:Body>
      </soap:Envelope>
    XML
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
            <ROClientIDHeader SOAP-ENV:mustUnderstand="0" xmlns="urn:Envialianet">
              <ID>--ID SESIÓN--</ID>
            </ROClientIDHeader>
          </SOAP-ENV:Header>
          <SOAP-ENV:Body xmlns:ro="urn:Envialianet">
            <v1:WebServService___GrabaEnvio8Response>
            <v1:strAlbaranOut>"--OUT ALBARAN--"</v1:strAlbaranOut>
            <v1:strCodTipoServOut>"--OUT TIPO SERVICIO--"</v1:strCodTipoServOut>
            <v1:dPesoVolpesOut>"--OUT PESO VOLPES--"</v1:dPesoVolpesOut>
            <v1:dAltoVolpesOut>"--OUT ALTO VOLPES--"</v1:dAltoVolpesOut>
            <v1:dAnchoVolpesOut>"--OUT ANCHO VOLPES--"</v1:dAnchoVolpesOut>
            <v1:dLargoVolpesOut>"--OUT LARGO VOLPES--"</v1:dLargoVolpesOut>
            <v1:dtFecEntrOut>"--OUT FECHA ENTREGA--"</v1:dtFecEntrOut>
            <v1:strTipoEnvOut>"--OUT TIPO ENVIO--"</v1:strTipoEnvOut>
            <v1:dtFecHoraAltaOut>"--OUT FECHA HORA ALTA en formato yyyy/mm/dd hh:mm:ss--"</v1:dtFecHoraAltaOut>
            <v1:dKmsManOut>"--OUT KILOMETROS--"</v1:dKmsManOut>
            <v1:boTecleDesOut>"--OUT TECLEADO DESTINO--"</v1:boTecleDesOut>
            <v1:strCodAgeOriOut>”--OUT AGENCIA ORIGEN--"</v1:strCodAgeOriOut>
            <v1:strCodAgeDesOut>”--OUT AGENCIA DESTINO--"</v1:strCodAgeDesOut>
            <v1:strCodProDesOut>"--OUT CODIGO PROVINCIA DESTINO--"</v1:strCodProDesOut>
            <v1:dPorteDebOut>"--OUT PORTE DEBIDO--"</v1:dPorteDebOut>
            <v1:strCodPaisOut>"--OUT CODIGO PAIS--"</v1:strCodPaisOut>
            <v1:boRetornoOut>"--OUT RETORNO--"</v1:boRetornoOut>
            <v1:strGuidOut>"--OUT GUID ENVIO--"</v1:strGuidOut>
            </v1:WebServService___GrabaEnvio8Response>
          </SOAP-ENV:Body>
        </SOAP-ENV:Envelope>
      XML
      headers: {}
    )
end
