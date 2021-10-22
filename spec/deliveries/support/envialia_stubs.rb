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
