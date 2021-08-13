include Savon::SpecHelper

def register_mondial_relay_wsdl
  wsdl = (File.open(File.expand_path("../..", __dir__) + '/fixtures/files/mondial_relay_wsdl.xml')).read

  stub_request(:get, 'http://api.mondialrelay.com/Web_Services.asmx?WSDL')
    .to_return(
      status: 200,
      body: wsdl,
      headers: {}
    )
end

def register_mondial_relay_get_collection_points_stubs

  # Success
  # ---

  message = {
    "Enseigne" => "test",
    "Pays" => "fr",
    "NumPointRelais" => "",
    "Ville" => "",
    "CP" => "00001",
    "Latitude" => "",
    "Longitude" => "",
    "Taille" => "",
    "Poids" => "",
    "Action" => "",
    "DelaiEnvoi" => "0",
    "RayonRecherche" => "",
    "TypeActivite" => "",
    "NACE" => ""
  }
  message['Security'] = Deliveries::Couriers::MondialRelay.calculate_security_param message

  savon.expects(:wsi3_point_relais_recherche).with(message: message)
    .returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI3_PointRelais_RechercheResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI3_PointRelais_RechercheResult>
            <STAT>0</STAT>
            <PointsRelais>
              <PointRelais_Details>
                <STAT />
                <Num>XXXXX1</Num>
                <LgAdr1>Collection point addr 1        </LgAdr1>
                <LgAdr2 />
                <LgAdr3>Collection point addr 3       </LgAdr3>
                <LgAdr4>Collection point addr 4        </LgAdr4>
                <CP>00001</CP>
                <Ville>Collection point ville                     </Ville>
                <Pays>FR</Pays>
                <Localisation1>Collection point localisation 1</Localisation1>
                <Localisation2 />
                <Latitude>-45.750594</Latitude>
                <Longitude>166.578292</Longitude>
                <TypeActivite>000</TypeActivite>
                <Information />
                <Horaires_Lundi>
                  <string>0930</string>
                  <string>1530</string>
                  <string>0000</string>
                  <string>0000</string>
                </Horaires_Lundi>
                <Horaires_Mardi>
                  <string>0930</string>
                  <string>1930</string>
                  <string>0000</string>
                  <string>0000</string>
                </Horaires_Mardi>
                <Horaires_Mercredi>
                  <string>0930</string>
                  <string>1930</string>
                  <string>0000</string>
                  <string>0000</string>
                </Horaires_Mercredi>
                <Horaires_Jeudi>
                  <string>0930</string>
                  <string>1930</string>
                  <string>0000</string>
                  <string>0000</string>
                </Horaires_Jeudi>
                <Horaires_Vendredi>
                  <string>0930</string>
                  <string>1930</string>
                  <string>0000</string>
                  <string>0000</string>
                </Horaires_Vendredi>
                <Horaires_Samedi>
                  <string>0930</string>
                  <string>1830</string>
                  <string>0000</string>
                  <string>0000</string>
                </Horaires_Samedi>
                <Horaires_Dimanche>
                  <string>0000</string>
                  <string>0000</string>
                  <string>0000</string>
                  <string>0000</string>
                </Horaires_Dimanche>
                <Informations_Dispo />
                <URL_Photo>https://ww2.mondialrelay.com/public/permanent/photo_relais.aspx?ens=CC______41&amp;num=095966&amp;pays=FR&amp;crc=58F2254909F43882DE4BB557A1EB40B0</URL_Photo>
                <URL_Plan>https://ww2.mondialrelay.com/public/permanent/plan_relais.aspx?ens=ESMICOLE38&amp;num=095966&amp;pays=FR&amp;crc=1F711F893523B52BDD77D0AF1109CA2A</URL_Plan>
                <Distance>910</Distance>
              </PointRelais_Details>
              <PointRelais_Details>
                <STAT />
                <Num>XXXXX2</Num>
                <LgAdr1>Collection point addr 1                  </LgAdr1>
                <LgAdr2 />
                <LgAdr3>Collection point addr 3       </LgAdr3>
                <LgAdr4 />
                <CP>00002</CP>
                <Ville>Collection point ville                   </Ville>
                <Pays>FR</Pays>
                <Localisation1 />
                <Localisation2 />
                <Latitude>-45.750594</Latitude>
                <Longitude>166.578292</Longitude>
                <TypeActivite>000</TypeActivite>
                <Information />
                <Horaires_Lundi>
                  <string>0000</string>
                  <string>0000</string>
                  <string>0000</string>
                  <string>0000</string>
                </Horaires_Lundi>
                <Horaires_Mardi>
                  <string>1000</string>
                  <string>1500</string>
                  <string>1530</string>
                  <string>2100</string>
                </Horaires_Mardi>
                <Horaires_Mercredi>
                  <string>1000</string>
                  <string>1500</string>
                  <string>1530</string>
                  <string>2100</string>
                </Horaires_Mercredi>
                <Horaires_Jeudi>
                  <string>1000</string>
                  <string>1500</string>
                  <string>1530</string>
                  <string>2100</string>
                </Horaires_Jeudi>
                <Horaires_Vendredi>
                  <string>1000</string>
                  <string>1500</string>
                  <string>1530</string>
                  <string>2100</string>
                </Horaires_Vendredi>
                <Horaires_Samedi>
                  <string>1000</string>
                  <string>1500</string>
                  <string>1530</string>
                  <string>2100</string>
                </Horaires_Samedi>
                <Horaires_Dimanche>
                  <string>1000</string>
                  <string>1500</string>
                  <string>1530</string>
                  <string>2100</string>
                </Horaires_Dimanche>
                <Informations_Dispo />
                <URL_Photo>https://ww2.mondialrelay.com/public/permanent/photo_relais.aspx?ens=CC______41&amp;num=001509&amp;pays=FR&amp;crc=7AB9594FF88212DD2A6A2F2B2A817C0A</URL_Photo>
                <URL_Plan>https://ww2.mondialrelay.com/public/permanent/plan_relais.aspx?ens=ESMICOLE38&amp;num=001509&amp;pays=FR&amp;crc=D34E77CE50E4AC82C5B5652914052BBA</URL_Plan>
                <Distance>3802</Distance>
              </PointRelais_Details>
            </PointsRelais>
          </WSI3_PointRelais_RechercheResult>
        </WSI3_PointRelais_RechercheResponse>
      </soap:Body>
    </soap:Envelope>
  ))

  # Error
  # ---

  message = {
    "Enseigne" => "test",
    "Pays" => "fr",
    "NumPointRelais" => "",
    "Ville" => "",
    "CP" => "00000",
    "Latitude" => "",
    "Longitude" => "",
    "Taille" => "",
    "Poids" => "",
    "Action" => "",
    "DelaiEnvoi" => "0",
    "RayonRecherche" => "",
    "TypeActivite" => "",
    "NACE" => ""
  }
  message['Security'] = Deliveries::Couriers::MondialRelay.calculate_security_param message

  savon.expects(:wsi3_point_relais_recherche).with(message: message).returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI3_PointRelais_RechercheResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI3_PointRelais_RechercheResult>
            <STAT>0</STAT>
            <PointsRelais />
          </WSI3_PointRelais_RechercheResult>
        </WSI3_PointRelais_RechercheResponse>
      </soap:Body>
    </soap:Envelope>
  ))

  message = {
    "Enseigne" => "test",
    "Pays" => "fr",
    "NumPointRelais" => "",
    "Ville" => "",
    "CP" => "",
    "Latitude" => "",
    "Longitude" => "",
    "Taille" => "",
    "Poids" => "",
    "Action" => "",
    "DelaiEnvoi" => "0",
    "RayonRecherche" => "",
    "TypeActivite" => "",
    "NACE" => ""
  }
  message['Security'] = Deliveries::Couriers::MondialRelay.calculate_security_param message

  savon.expects(:wsi3_point_relais_recherche).with(message: message).returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI3_PointRelais_RechercheResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI3_PointRelais_RechercheResult>
            <STAT>40</STAT>
            <PointsRelais />
          </WSI3_PointRelais_RechercheResult>
        </WSI3_PointRelais_RechercheResponse>
      </soap:Body>
    </soap:Envelope>
  ))
end

def register_mondial_relay_get_collection_point_stubs

  # Success
  # ---

  message = {
    "Enseigne" => "test",
    "Pays" => "fr",
    "NumPointRelais" => "XXXXX1",
    "Ville" => "",
    "CP" => "",
    "Latitude" => "",
    "Longitude" => "",
    "Taille" => "",
    "Poids" => "",
    "Action" => "",
    "DelaiEnvoi" => "0",
    "RayonRecherche" => "",
    "TypeActivite" => "",
    "NACE" => ""
  }
  message['Security'] = Deliveries::Couriers::MondialRelay.calculate_security_param message

  savon.expects(:wsi3_point_relais_recherche).with(message: message)
    .returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI3_PointRelais_RechercheResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI3_PointRelais_RechercheResult>
            <STAT>0</STAT>
            <PointsRelais>
              <PointRelais_Details>
                <STAT />
                <Num>XXXXX1</Num>
                <LgAdr1>Collection point addr 1        </LgAdr1>
                <LgAdr2 />
                <LgAdr3>Collection point addr 3       </LgAdr3>
                <LgAdr4>Collection point addr 4        </LgAdr4>
                <CP>00001</CP>
                <Ville>Collection point ville                     </Ville>
                <Pays>FR</Pays>
                <Localisation1>Collection point localisation 1</Localisation1>
                <Localisation2 />
                <Latitude>-45.750594</Latitude>
                <Longitude>166.578292</Longitude>
                <TypeActivite>000</TypeActivite>
                <Information />
                <Horaires_Lundi>
                  <string>0930</string>
                  <string>1530</string>
                  <string>0000</string>
                  <string>0000</string>
                </Horaires_Lundi>
                <Horaires_Mardi>
                  <string>0930</string>
                  <string>1930</string>
                  <string>0000</string>
                  <string>0000</string>
                </Horaires_Mardi>
                <Horaires_Mercredi>
                  <string>0930</string>
                  <string>1930</string>
                  <string>0000</string>
                  <string>0000</string>
                </Horaires_Mercredi>
                <Horaires_Jeudi>
                  <string>0930</string>
                  <string>1930</string>
                  <string>0000</string>
                  <string>0000</string>
                </Horaires_Jeudi>
                <Horaires_Vendredi>
                  <string>0930</string>
                  <string>1930</string>
                  <string>0000</string>
                  <string>0000</string>
                </Horaires_Vendredi>
                <Horaires_Samedi>
                  <string>0930</string>
                  <string>1830</string>
                  <string>0000</string>
                  <string>0000</string>
                </Horaires_Samedi>
                <Horaires_Dimanche>
                  <string>0000</string>
                  <string>0000</string>
                  <string>0000</string>
                  <string>0000</string>
                </Horaires_Dimanche>
                <Informations_Dispo />
                <URL_Photo>https://ww2.mondialrelay.com/public/permanent/photo_relais.aspx?ens=CC______41&amp;num=095966&amp;pays=FR&amp;crc=58F2254909F43882DE4BB557A1EB40B0</URL_Photo>
                <URL_Plan>https://ww2.mondialrelay.com/public/permanent/plan_relais.aspx?ens=ESMICOLE38&amp;num=095966&amp;pays=FR&amp;crc=1F711F893523B52BDD77D0AF1109CA2A</URL_Plan>
                <Distance>910</Distance>
              </PointRelais_Details>
            </PointsRelais>
          </WSI3_PointRelais_RechercheResult>
        </WSI3_PointRelais_RechercheResponse>
      </soap:Body>
    </soap:Envelope>
  ))

  # Error
  # ---

  message = {
    "Enseigne" => "test",
    "Pays" => "fr",
    "NumPointRelais" => "XXXXXX",
    "Ville" => "",
    "CP" => "",
    "Latitude" => "",
    "Longitude" => "",
    "Taille" => "",
    "Poids" => "",
    "Action" => "",
    "DelaiEnvoi" => "0",
    "RayonRecherche" => "",
    "TypeActivite" => "",
    "NACE" => ""
  }
  message['Security'] = Deliveries::Couriers::MondialRelay.calculate_security_param message

  savon.expects(:wsi3_point_relais_recherche).with(message: message).returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI3_PointRelais_RechercheResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI3_PointRelais_RechercheResult>
            <STAT>70</STAT>
            <PointsRelais />
          </WSI3_PointRelais_RechercheResult>
        </WSI3_PointRelais_RechercheResponse>
      </soap:Body>
    </soap:Envelope>
  ))
end

def register_mondial_relay_create_shipment_stubs

  # Success
  # ---

  savon.expects(:wsi2_creation_etiquette).with(message: {
    "Enseigne" => "test",
    "ModeCol" => "CCC",
    "ModeLiv" => "24R",
    "NDossier" => "shipmentX",
    "NClient" => "",
    "Expe_Langage" => "ES",
    "Expe_Ad1" => "SENDER NAME",
    "Expe_Ad2" => "",
    "Expe_Ad3" => "SENDER STREET",
    "Expe_Ad4" => "",
    "Expe_Ville" => "ERANDIO",
    "Expe_CP" => "48950",
    "Expe_Pays" => "ES",
    "Expe_Tel1" => "+34999999999",
    "Expe_Tel2" => "",
    "Expe_Mail" => "sender@example.com",
    "Dest_Langage" => "ES",
    "Dest_Ad1" => "RECEIVER NAME",
    "Dest_Ad2" => "",
    "Dest_Ad3" => "RECEIVER STREET",
    "Dest_Ad4" => "",
    "Dest_Ville" => "ERANDIO",
    "Dest_CP" => "48950",
    "Dest_Pays" => "ES",
    "Dest_Tel1" => "+34999999999",
    "Dest_Tel2" => "",
    "Dest_Mail" => "receiver@example.com",
    "Poids" => "1000",
    "Longueur" => "",
    "Taille" => "",
    "NbColis"=>1,
    "CRT_Valeur" => "0",
    "CRT_Devise" => "",
    "Exp_Valeur" => "",
    "Exp_Devise" => "",
    "COL_Rel_Pays" => "ES",
    "COL_Rel" => "XXXXX1",
    "LIV_Rel_Pays" => "ES",
    "LIV_Rel" => "XXXXX1",
    "TAvisage" => "",
    "TReprise" => "",
    "Montage" => "",
    "TRDV" => "",
    "Assurance" => "",
    "Instructions" => "",
    "Security" => "C8211E35CC7508579470330998AAA526"
  }).returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI2_CreationEtiquetteResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI2_CreationEtiquetteResult>
            <STAT>0</STAT>
            <ExpeditionNum>31297410</ExpeditionNum>
            <URL_Etiquette>/ww2/PDF/StickerMaker2.aspx?ens=test11&amp;expedition=31297410&amp;lg=ES&amp;format=A4&amp;crc=EC60EED67AF9052EEA4394F6964C0EBF</URL_Etiquette>
          </WSI2_CreationEtiquetteResult>
        </WSI2_CreationEtiquetteResponse>
      </soap:Body>
    </soap:Envelope>
  ))

  # Error
  # ---

  savon.expects(:wsi2_creation_etiquette).with(message: {
    "Enseigne" => "test",
    "ModeCol" => "CCC",
    "ModeLiv" => "HOM",
    "NDossier" => "shipmentX",
    "NClient" => "",
    "Expe_Langage" => "ES",
    "Expe_Ad1" => "SENDER NAME",
    "Expe_Ad2" => "",
    "Expe_Ad3" => "SENDER STREET",
    "Expe_Ad4" => "",
    "Expe_Ville" => "ERANDIO",
    "Expe_CP" => "48950",
    "Expe_Pays" => "ES",
    "Expe_Tel1" => "+34999999999",
    "Expe_Tel2" => "",
    "Expe_Mail" => "sender@example.com",
    "Dest_Langage" => "ES",
    "Dest_Ad1" => "",
    "Dest_Ad2" => "",
    "Dest_Ad3" => "RECEIVER STREET",
    "Dest_Ad4" => "",
    "Dest_Ville" => "ERANDIO",
    "Dest_CP" => "48950",
    "Dest_Pays" => "ES",
    "Dest_Tel1" => "+34999999999",
    "Dest_Tel2" => "",
    "Dest_Mail" => "receiver@example.com",
    "Poids" => "1000",
    "Longueur" => "",
    "Taille" => "",
    "NbColis"=>1,
    "CRT_Valeur" => "0",
    "CRT_Devise" => "",
    "Exp_Valeur" => "",
    "Exp_Devise" => "",
    "COL_Rel_Pays" => "",
    "COL_Rel" => "",
    "LIV_Rel_Pays" => "",
    "LIV_Rel" => "",
    "TAvisage" => "",
    "TReprise" => "",
    "Montage" => "",
    "TRDV" => "",
    "Assurance" => "",
    "Instructions" => "",
    "Security" => "E1FCC672CB1290C1C1E44E2A5643AF38"
  }).returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI2_CreationEtiquetteResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI2_CreationEtiquetteResult>
            <STAT>30</STAT>
          </WSI2_CreationEtiquetteResult>
        </WSI2_CreationEtiquetteResponse>
      </soap:Body>
    </soap:Envelope>
  ))
end

def register_mondial_relay_create_pickup_stubs

  # Success
  # ---

  savon.expects(:wsi2_creation_etiquette).with(message: {
    "Enseigne" => "test",
    "ModeCol" => "REL",
    "ModeLiv" => "LCC",
    "NDossier" => "shipmentX",
    "NClient" => "",
    "Expe_Langage" => "ES",
    "Expe_Ad1" => "SENDER NAME",
    "Expe_Ad2" => "",
    "Expe_Ad3" => "SENDER STREET",
    "Expe_Ad4" => "",
    "Expe_Ville" => "ERANDIO",
    "Expe_CP" => "48950",
    "Expe_Pays" => "ES",
    "Expe_Tel1" => "+34999999999",
    "Expe_Tel2" => "",
    "Expe_Mail" => "sender@example.com",
    "Dest_Langage" => "ES",
    "Dest_Ad1" => "RECEIVER NAME",
    "Dest_Ad2" => "",
    "Dest_Ad3" => "RECEIVER STREET",
    "Dest_Ad4" => "",
    "Dest_Ville" => "ERANDIO",
    "Dest_CP" => "48950",
    "Dest_Pays" => "ES",
    "Dest_Tel1" => "+34999999999",
    "Dest_Tel2" => "",
    "Dest_Mail" => "receiver@example.com",
    "Poids" => "1000",
    "Longueur" => "",
    "Taille" => "",
    "NbColis"=>1,
    "CRT_Valeur" => "0",
    "CRT_Devise" => "",
    "Exp_Valeur" => "",
    "Exp_Devise" => "",
    "COL_Rel_Pays" => "XX",
    "COL_Rel" => "AUTO",
    "LIV_Rel_Pays" => "",
    "LIV_Rel" => "",
    "TAvisage" => "",
    "TReprise" => "",
    "Montage" => "",
    "TRDV" => "",
    "Assurance" => "",
    "Instructions" => "",
    "Security" => "87A30BE66879F6A774A165D808E06A17"
  }).returns(%(
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI2_CreationEtiquetteResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI2_CreationEtiquetteResult>
            <STAT>0</STAT>
            <ExpeditionNum>31297410</ExpeditionNum>
            <URL_Etiquette>/ww2/PDF/StickerMaker2.aspx?ens=test11&amp;expedition=31297410&amp;lg=ES&amp;format=A4&amp;crc=EC60EED67AF9052EEA4394F6964C0EBF</URL_Etiquette>
          </WSI2_CreationEtiquetteResult>
        </WSI2_CreationEtiquetteResponse>
      </soap:Body>
    </soap:Envelope>
  ))

  # Error
  # ---

  savon.expects(:wsi2_creation_etiquette).with(message: {
    "Enseigne" => "test",
    "ModeCol" => "REL",
    "ModeLiv" => "LCC",
    "NDossier" => "shipmentX",
    "NClient" => "",
    "Expe_Langage" => "ES",
    "Expe_Ad1" => "SENDER NAME",
    "Expe_Ad2" => "",
    "Expe_Ad3" => "SENDER STREET",
    "Expe_Ad4" => "",
    "Expe_Ville" => "ERANDIO",
    "Expe_CP" => "48950",
    "Expe_Pays" => "ES",
    "Expe_Tel1" => "+34999999999",
    "Expe_Tel2" => "",
    "Expe_Mail" => "sender@example.com",
    "Dest_Langage" => "ES",
    "Dest_Ad1" => "",
    "Dest_Ad2" => "",
    "Dest_Ad3" => "RECEIVER STREET",
    "Dest_Ad4" => "",
    "Dest_Ville" => "ERANDIO",
    "Dest_CP" => "48950",
    "Dest_Pays" => "ES",
    "Dest_Tel1" => "+34999999999",
    "Dest_Tel2" => "",
    "Dest_Mail" => "receiver@example.com",
    "Poids" => "1000",
    "Longueur" => "",
    "Taille" => "",
    "NbColis"=>1,
    "CRT_Valeur" => "0",
    "CRT_Devise" => "",
    "Exp_Valeur" => "",
    "Exp_Devise" => "",
    "COL_Rel_Pays" => "XX",
    "COL_Rel" => "AUTO",
    "LIV_Rel_Pays" => "",
    "LIV_Rel" => "",
    "TAvisage" => "",
    "TReprise" => "",
    "Montage" => "",
    "TRDV" => "",
    "Assurance" => "",
    "Instructions" => "",
    "Security" => "876957F524EB62279E8D96371C9545BD"
  }).returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI2_CreationEtiquetteResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI2_CreationEtiquetteResult>
            <STAT>30</STAT>
          </WSI2_CreationEtiquetteResult>
        </WSI2_CreationEtiquetteResponse>
      </soap:Body>
    </soap:Envelope>
  ))
end

def register_mondial_relay_get_label_stubs

  # Success
  # ---

  savon.expects(:wsi3_get_etiquettes).with(message: {
    "Enseigne" => "test",
    "Expeditions" => "E001",
    "Langue" => "FR",
    "Security" => "B351449343E158B37FCD6AE7394581FD"
  }).returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI3_GetEtiquettesResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI3_GetEtiquettesResult>
            <STAT>0</STAT>
            <URL_PDF_A4>/ww2/PDF/StickerMaker2.aspx?ens=test11&amp;expedition=E001&amp;lg=FR&amp;format=A4&amp;crc=585C8413D5BC74EF6C7B2A620CED8366</URL_PDF_A4>
            <URL_PDF_A5>/ww2/PDF/StickerMaker2.aspx?ens=test11&amp;expedition=E001&amp;lg=FR&amp;format=A5&amp;crc=585C8413D5BC74EF6C7B2A620CED8366</URL_PDF_A5>
            <URL_PDF_10x15>/ww2/PDF/StickerMaker2.aspx?ens=test11&amp;expedition=E001&amp;lg=FR&amp;format=10x15&amp;crc=585C8413D5BC74EF6C7B2A620CED8366</URL_PDF_10x15>
          </WSI3_GetEtiquettesResult>
        </WSI3_GetEtiquettesResponse>
      </soap:Body>
    </soap:Envelope>
  ))

  stub_request(:get, "http://www.mondialrelay.com/ww2/PDF/StickerMaker2.aspx?ens=test11&expedition=E001&lg=FR&format=10x15&crc=585C8413D5BC74EF6C7B2A620CED8366").
    with(
      headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Ruby'
      }
    )
    .to_return(
      status: 200,
      body: "%PDF-1.4\n1 0 obj\n<<\n/Title (\xFE\xFF\x00U\x00n\x00b\x00e\x00n\x00a\x00n\x00n\x00t)\n/Creator (\xFE\xFF)\n/Producer (\xFE\xFF\x00Q\x00t\x00 \x004\x00.\x008\x00.\x003\x00 \x00\\(\x00C\x00\\)\x00 \x002\x000\x001\x001\x00 \x00N\x00o\x00k\x00i\x00a\x00 \x00C\x00o\x00r\x00p\x00o\x00r\x00a\x00t\x00i\x00o\x00n\x00 \x00a\x00n\x00d\x00/\x00o\x00r\x00 \x00i\x00t\x00s\x00 \x00s\x00u\x00b\x00s\x00i\x00d\x00i\x00a\x00r\x00y\x00\\(\x00-\x00i\x00e\x00s\x00\\))\n/CreationDate (D:20140512092444)\n>>\nendobj\n2 0 obj\n<<\n/Type /Catalog\n/Pages 3 0 R\n>>\nendobj\n4 0 obj\n<<\n/Type /ExtGState\n/SA true\n/SM 0.02\n/ca 1.0\n/CA 1.0\n/AIS false\n/SMask /None>>\nendobj\n5 0 obj\n[/Pattern /DeviceRGB]\nendobj\n6 0 obj\n<<\n/Type /Page\n/Parent 3 0 R\n/Contents 8 0 R\n/Resources 10 0 R\n/Annots 11 0 R\n/MediaBox [0 0 595 842]\n>>\nendobj\n10 0 obj\n<<\n/ColorSpace <<\n/PCSp 5 0 R\n/CSp /DeviceRGB\n/CSpg /DeviceGray\n>>\n/ExtGState <<\n/GSa 4 0 R\n>>\n/Pattern <<\n>>\n/Font <<\n/F7 7 0 R\n>>\n/XObject <<\n>>\n>>\nendobj\n11 0 obj\n[ ]\nendobj\n8 0 obj\n<<\n/Length 9 0 R\n/Filter /FlateDecode\n>>\nstream\nx\x9C\x9D\x92K\n\xC20\x10\x86\xF7s\x8A\xB9@\xD3\xBC\x1F \x82\xAD\xD5ui. \x15\x05\xA1b\xE9\xFD\xC1&\xA9\xE0f6\xCD\xC0L\xC8\xF7O\xFE\x90\xA4\xBE\x0E7|.X\xB7\xC3\a\xC7\xAD\xB6\x03p\xE6\xB4\x94\xD6s-\x90\xAFQ\xFD/\x04fu\xD0^\e\x85^I\xA6\f7\xC2\xE08\xC1\x8C3\xF4\xD0\xAF9\xD5\x94Kw\xC9\xAB\xE0g\xC3s,\xE3\e\xEAr\x00h\"\xD4\x17\x87B2\xA1x\x1A\x18\x1F[_UJ\x9C \xCD%\xC6;\x1EV\x818b|\x81c2X\xEF\f\xCF\x92B$I\xD4\x8E\x1E\xDAG\x93\xC4\x90\xC4\x92\xC4\x91\xC4\x93$\xEC\xF0\xA1w;\x91\xA4!I\xBB\xE3\xDE\xCE;\xDE\xA7\xCB\xA4\x8B\xF9\x7F\xF5\xF0\x05\x94\xF8\x93\xD4endstream\nendobj\n9 0 obj\n192\nendobj\n12 0 obj\n<< /Type /FontDescriptor\n/FontName /QMAAAA+DejaVuSansMono\n/Flags 4 \n/FontBBox [-557.617187 -374.511718 717.773437 1041.50390 ]\n/ItalicAngle 0 \n/Ascent 928.222656 \n/Descent -235.839843 \n/CapHeight 928.222656 \n/StemV 43.9453125 \n/FontFile2 13 0 R\n>> endobj\n13 0 obj\n<<\n/Length1 10256 \n/Length 16 0 R\n/Filter /FlateDecode\n>>\nstream\nx\x9C\xC5Z\x7F\x8C\x13W~\x7F\xCFk\x16\xD8$\x84\r\xBB\xD0\x8A_\x0F\x13X(\xC6KvY6\xE1\b\xC1k\xCF\xEE\x1A\xBC\xF6b{\x17\b$\xEC\xD83^O\xD6\x9Eqf\xC6,\e.M\xB9KHOMJr\xA8\x84K9D\xA2kC\x9BF\x95\xAE\xD2e\xB9JQ{\xE9\x1F\xED\xF5\xA4\x88SQZ\xE9$\x94\xA4W5\xD7Sz\xADz\xEAE\x81\xA5\xDF\xF7}o\xFC\x8B\rA\xB9V]\xC7\xF6\x9B7\xDF\xF7\xFD~\xBE\x9F\xEF\x8F\xF7<\x84PB\xC8\"\xF2;\xA4\x85\x90d\xBA\xBB\xE7\x85\xEB\xC6wa\xE6\x05x\x8FO\x16g\xF2\x0F\xEFyy\t\x8C\xFF\x99\x90\x05\xBB\n\xBA\xAA\xE5\xBE\x16+\x13\xD2\xCA`nG\x01&\xEE\xBA\xE6\v\xC0\xF5A\xB8\xBE\xBFPr\x8F\x0F?\xB2\xE88\\\x7F\x15\xAEw\x15\xAD\x9C\xBA\xF8\xA9\xB6\xBF\x84\xEBY\xB8f%\xF5x\x99\xDCGv\xC0\xF5?\xF2kS-\xE9\x13\x1F\xFD\xECw\xE1\xFAW\x84\xAC\xEB$\xD4\x7F\x85\xBED\x16\x80\xAD\xDE\x05\xDF\"\x84\xAE\x11\xDF-\xEF\x93\xBC\xEF>B|w\xB5.nY\xE4\xF7\xF9\xFC\xFFB6\xDE\xFC1\xF9\xF43\x1F!\x9B@\x13\x19\xCD+\x1A\xD9C\xD8\xCD\x9B\xAD\x1Ds\x1D\xF4\xD5\x85%\xFA\xD1\x04\xA1\xD7\xAE]\xE3w\x89\x8F\x14\xE6\xCE\xFA\v\v\xBE\x03^.$dY\xFB\xBA\xF6\r\xEB\xDA\xD7\x15\xFC\xE4\xBA\xD3\xB2\xF2\xFAO\xE7\xCE.\\\xF2\xAB\xFF\xB4[7\x13JJ\x84\xF8-\xFF\t\xF2[`\x7FG\xFF\x8E\xDE\xE5+\x96\xB7\xB7\xAFo\xDF\xD8\xB5q}`ak'\f\xB7wm\xEC\x92\xC3\xDEN)\xE2\xFBN\xA0o\xFB\xDE\xE7\x1F\xEC\xBFD\x7Fs\xE5\xE0\xFEUk.\xADZ\x13\xDB\xBBr\xF5\eo\xAC\xEBy\xE0\x91x\xEF\x03-\x9F\f\xAF\x0F\xD0Ic\xEE\xDA\x8Di\xDF\xC9\x9F\x7F\xE5\xA1\x87w\xFF\xF4\xC63\xBE\x93\xBFx\xB0\x9F\xE2\xD0?1\xB1\x8B\xAD\xA5\x81\xFB\x01-D\xC0\x1Fm\xED \x8B\xC9=\x80\x02\x90v\xAE\xEB\x83O\xDA\xDB\xB9\x9E\x12\xFA>-]7ii\xEE\x03\xBAvv\xD6?q\xBD\xFB\xF4\xE9\x96\x01_\xE4c\x10%\xEF\xC2\xCA\x95\x80~\x05\\\b\xD4\x1C\xEA\x8A*\xD4\x9E\x15\xCB\xFD+/\xD3\xED;\xCA'\x95!:;\xFB@&\xED\xFE\xE9x\xC6\xF7\xBD\e{}\xDF{eh\x90\x1E>\xF2\xE6\x8D\xE7\xFD\x13\x97&z\x1E(?\xC9\x99{\xEE\xE6\x87\xFE\xF5\xA0q\t\xD9\x0E:\xD7\xB7\x82\xB6\xD6\x15\xCB{\x97\xF7\xEF\xE8\xEF\xEBo_\xDF\a\x13\xEB[\xBB6\xF6m\a\xED\xBD}\x92\xA6\x85}\x92\x17\xFE\xF2\xBD\xF3\xF0k\xFB\xD3\x94\xEE~\xB8\xF8\xCA\xC1q\xDF\xE5\xCB\xBB\x0E\x1E~\xE6\xCD|\xFE\xB7\xBF\xFA_\xFF\xED\e\x88~\xF3\xE8\xD1\x89\xC3\xFA\xD1#\x87~/\xA7\xEE\xDE\xD0\xBE\xD4\xD7K\xFB\x1F*\xE7\xFB\x1F\xA4S\xC6\xF77\xC7o\x9C\xFCc=\xB4\x8Df'^\xFF~V]\xFD\xDC\xEE]+Wn\x9F\xED\xEAXF7mN\xF5\xC4\xF6\x82\xCF\x17o\xDE\xF4\xB7\xB5\xAE%\xF7\x02>\x0E\rX\x02@\xFD\xED\xC0\x99\xEF\x19\xDA\xBD\xF5\xD0\xFB\x1F\xFF\xD1\xA3G\xE8\xDC?\xD1k\xF4\xEC\xD3\xBB\x1F9O\xA7\x9E\xF8A\xCB\xA7/q\xEF\xDE\x99\e\xF7g\xC0\xBB\x0Er?!\e\xEAij\xF7\x81c\x81\xAE\x8Dt\xBB\x8C|\x87\xF0\x9AN_\xBE\x1C\x1A\xD9\xA7\xFF\xB0\xE2P\xC7\xFDa>\x9E\xA0\xFF\x11\x89>wJ\x81\xBFS\xCFE#/\xDE\xF8\xBB\xD6\xB6\xD3\xA9\xAD[\xBE}a\xEE\xDF\xE6>y\xF5|p\v\xFD\xE5U\xB3T2\xAF^-\x99\xD4,\x82\xD5\x137?\xF2\xDF\a\xF1E\xAB\xB4\xBDW\xD2\b\xD6\xDA\x97\x02\xAF`\x9D\x82\xB5\xFE\x9E\xFE\x1D}\xD2z\xCB\xA3\xB3\xB3\xDD\xFBF\xB4\x1F9\x95\x8A\xFB\xF7Z\">\xB74\x1A9\xF5\xEC\x90\xA2\f={*\x12m\xB9\xE2\x8B|\xFA\xF3\x17\xD3[\x82\x17\xCE\xD3\xE5\xB4\xFD\xFC\xABt\xCB\xD6\xB9\xBB\xDF/\x82\xC1\xD2U\xB4\xEEeG\x17\xD8\xED\x84\x8BNt\xAA\x13R\v\xBC\x06\xAA\xFA6\x82\xDF\xFE\xAE+\xDA\x86.zr\xEE\x99\xD9\xB9\xABt\v\x1D\xCF\xFCEk\xC7\xB76m\x9E\xCC\x9D\xBE\xDE\xDDr\xE5tb\xF6\xC0\x01\xC0\xFF\r\xC8\x89a`\xED^\xB2\x164y\xE4H\xB8]\x9C\xBC\xA5\v[\xBBZ\x85;\xBE\xC2\v\xC3\xF0\xF7\xC2\x8B\xFC\xF3\xC5\x7F}\xFA\xC4\x89\x13?\xFB\x18>N\xB4\\\x13\x9C\b\x84\xE7_97\xF7\xD1\xDC\ag\xCFQz\xEE,]KW\x9F{\x85#\x06K\e\xC0\xD2:\x88\x0EP\xD4\xC5\x84\xCEu`cE\xA7\xCC\xEE\xCEVa\xBC\xDF\xBFaobt\xFF\xDCg/\x9F9\xF32]\xB0\x7F$\x9E\xDC;\xBC\xF7\xB1\xB7\x1E{\x8C\x1E=\xF2\xD6\xD1\x91x\xF8\xA1`\xC7\nz\xFE<\xED\xA0\x1D\xE7\xCFw.\xDF\xF2\xD7{\xD6\xAC\xA2\xE5'\xDF{\xAF\xFC\xE4\x9AU\x8F C\x10\x99\x95\xFE\xC7y\xFD,\x83\xB8xn\xD5\x87\xE8\xDD\xD9\x1D\xDB\x9F\xFC\x9A\xA2\\\xBE\xDC\x93\x1E/\xBF\x95\xCE\xD0K\xBC|\xCE\r\x0E\x1D9\xFC\xA6o\xE6\xB3\xD7/e\x1F\xE8y\xB2L0\xCE\x1F\xFA\x0F\x02\xFA\x95\x18g\xE0\x9AG\x95WN'\xF7\xC5/|\xE1\xC9\xB6\xD0\xAB\e\xFF\xC1\xEB\x1FM<\xFE\xE7\a'\x8E\x9A\x86\x9A=<\xF7\xD9\x993/\xBD\xF4\x8B\xABO\x9F\x98]0\xB4\xF7\xF9Sc\xE3K}\x8F?\xDA\xFA\xB6\xA6S\xBAz\xD5Cos\x7F(\x84|\x19\xBD\xEB\xB5\x8B/\x7F\xF3o^\e\xCF\x1C<\xF4\x87\xE0\xC7\xD7!\xD2\x8B\x16\\\xC0H\xF3\xF6\xC1=\xE9\x87\xC2\b\xC8\xC2h\xF7\xE5\xE9\xEBs\x8Fw\x87\x8E\xBD\xF7\xC1{c\xE3\x94G{\xC1\x85\xB9\x1F\x9C\xBEq\xF1\xE9m=\xF4L:\xF5#\xDF\xC4i\xBA\x9Bs\x82\xEF\x8B?\xF9\x93=G\xEF\xDD\xF5K\xBEY\xDC\xFA\aUdA\x05R\xD2Z\x9D\x825\vKs\xAB\x01\xC7\x05Bn\x1E\xF0[\xA8\xA9\xFE\xEF^\xFF\x15R\x80w\t\xDE\xDF\x85\xF7\xBB\xF0~\x0E\xDE\x17\xE1M\xE0\xFD\x0E\xBCO\xC8\xF9o\xC8\xEFw\xE5\x1C\xF8\a\xBE\x1D .\xF96\xF9\x84\xDE\r\xAF!\xFAu\xFA\x06\xFD\x89\xAF\xC3\xF7\x15\xDFq\xDF\x05\xB4v/\xE9\x83(H4\xB7\xFC-\xA7K\xAA\xF3G\xC9_\xC91%K\xE9\x80\x1C\xFB\x88\x9F>&\xC7-0\xFF\xAC\x1C\xFBa\xFC\xB6\x1C/ w\xD3\x0F\xE5\xB8\x95,\xF1\xDD#\xC7\x8BH\xBBo\x8F\x1C\xDFEV\xFB~_\x8E\xEFY|\xA6\xF3\x1F\xE4\x18z\xEA\xDA\x1F\x83f\xEA_\fW\xEF\xA0\x15>\xA6\x84Q&\xC7>\xB2\x88\xA6\xE5\xB8\x05\xE6\xB3r\xEC\x87\xF1\x1F\xC8\xF1\x02\xF2\e\xF4o\xE5\xB8\x95\xAC\xA2\xFF.\xC7\x8BH\xC0\xB7J\x8E\xEF\";})9\xBEg\xD9F\xDF\x9F\xC9\xF1\x12RX[ \x11b\x912\x99!61\xC8$)\x00\xAF\fv\xD6\x1C\xD9\f\xDF=d\e\xBCza\x94\x05\tF\x06@\xC6%\x0E\xBCm\xA2\x13\x15v\xCC \xCC\xC6\x88\t\xF2!\x18\x85I\x11^\x8C\xA4\xAA\xBA\x1C\xBC\xD2\xE1[\x875\xC7\xE0S\x03\xC96\x12\x85\xD1\x13\xA0a\x9CT@\"\a\xB2*h\x99DI\x06c\xAE\x9F\x81\x16\x13>\xCB \x93\x05\xBD\x06\xC81Xo\x81]\x15\xEF\xB5\x11\x12\xB1\xCA3\xB61Yp\xD9\xA6\xDCf\xD6\xB3m[/\xCB\xCE\xB0\x01\xC3u\\[WKA\x163s!\x16.\x16Y\x8AK9,\xA5;\xBA}L\xD7BmQ\xFD\tu\xBC\xC2r\x05\xD5\x9C\xD4\x1D\xA6\xDA:3LV\xAEd\x8BF\x8EiVI5L0\xD0\x884\x8D89\xC6\x11\xC0a\xC2\x9BH5i\xD5t\xD8\x88e\xC2\xCC\x00L[d\n\x06\x965\xF5\xA54|\x89%\xE3\xC8\xB0\x03\xBCX\xC8Z\x0F\xF0\xDC\v/2\xAE\xDB\x8Ea\x99\xAC'\xD4\xDB\xDB\xA8\xD9\xD3\xDB\xA4\x95+\x9D\x0FF\x1E\xC5DL]\x19\x7F\x0FH\xDE2\x81[\x17\x18'\x18w\x17\xA2\xB6\x93t\xC3K\x93:\x8E\x81\x8E\x10\xAC\xB5\xE0\xDB\x86H\xEA\xA8\xCF\xC6\x98\x87@\xAF\x0EkH\xC1u\xCB;\xBB\xBB5Pz\xAC\x12r\xAC\x8A\x9D\xD3\xF3\x96=\xA9\x87L\x1Dn\x0F\xD6!\xF0r\xC4\xCB\xD5[s\x93\xDF\xE3y\xA7c\xFE\xEA\x90A\x16\x99\x06Y\x9E\xA9\xFF;\xF9\xC73\xB9m^\xCB\"\x1A*\x8C\xEA1\xDFZkmd\xEB\xAF\xF1\xE2\xD6\xFF?\xEAw~\xB6k>\e\x92E\x86\xF7U\xCC\x81\x12\xB2:\x05s\x16D\xFE\x8B\xB0p\xCFFQ_\t\xB5\xD5\xF2Z\xE8.\xE0=]\xFA5\x89VL\xCCJ\r\xF5\xE4\xF1\xAE^\xB5&\",\xB2-\x88\xB8,Dh\xE2\xFA\xB2\xAC\x1Da\xC1\x02\xAD\xAE\x8C\xB0\x81Y!|\xC9I\xA6=\x9D.\xA2h\xAC\v\x15\xA4r\x98!e\xA9\xDD\xD3\xC0\xA5\x05v\x91I:\x96\x9E\xC8\xE0@]\x96\x040r|\xAD\x86\xDF\x0E\xE2\xCA\xC1\x1AU\xFA'r0\aYYB-.\xDE\xF1\xF8\xC9\xC3\xA8(\xF3xS\x15c\xCD\x02o'\x1C\xBF\v\xB5 \xF2\x9C[\xACq\xC2g\xCA\xF0i\x81\x95\n\xE2\xAC\xA1\xD1\xD0\x03\x17s-\vw]\xBC\xEB\xD9\xF8|\vAYK9@VA-\x82\x93i\xCC\x81\x02\xF6\x04W2S\xC2\xB9z\x8F<\xFDvCV\n\xB4\x15\xE40X\x17\x1D>.a<\xBDX\xD7\xEA\xD7\x81\xD5\xC1\xCF\xF1#X\xF5\xB3\e\xFB\x12C\xCD\xA2\x1E\x84nC\xB2\xDA\x18\xFD\xDB{\xED1'\xD0\x96\xAB\x19\xED6e]\xCD\xA3i\xE4\xA3tG\x16\xBCj\xC8cO5\xA5\x87z\x9DE\r?\xB9\x8D ~s&\x9E\x00\x89\x1C\xEA\x132\xF5y\\\x94]\xD2\x8BP\x0Emk\x88\xD8\x90Hwbuf\xE4*\x154Z\xD8\x19j1\xA8\xEFE5\x06n\xED\x04|\xD3qe58\r\xB2^\xAD\xD4\x18\xAB\xEF\x01\xF5\xEB\x18\xFA\xAC\xCAHe\xAB}\xDB\xCB5\xC1\x86\xE8\xE4\xEAm\xE2i\xE1\x1E\xC4d\xECK\xF8]\xEB\x1Fw\x12\v\x17</\xE3\xBE\xA6J\x8FB\rL\xDDn-\xE7d\xA6\x8A\xBF\x84\xD5g`-{\x1D\x8Dcwe\xD7\x133\x02)\xE7T\xAB\x8By}\xD6y\xFB\x17\xB7\"\xF8\xAA\x80\x16\x15\xD7y\x1Ei\x88\x94\xC7\xCB\xACcc\x12\xE4\xB87\x059g\xD7\xF5P\x15\xB3G\xE4\xAEg\xA3\x99\x1F\xE7\v}\xAA\xEFqZC\x86\xA9\x18\xA3\xF9\x10\xDC\x1EI\xA3\xBDf^\xE6\xC3\x18\x94q/\xE2:\xE36]\xDD\x96\x1DHG|\xA5\x06\xBD\xDE\x8CS\xCDL\xAFn\x9Aw\x11]\xF6;\xBD!\x02\xD3\xE8\x95\x86\xEB\x03\xF3\xEC\x8B\x81\xAA\xDF\xCD+\xB8\xBC\xB7\xEB\x06\xEA\xB2M\xD4N\xBCi\x9F\xC9b\xDD[uX+\xB2\x1E\xBCH\x1C\x83\xBB\xC6<\x8C\xE9\xE48\xF2l\xCA\x8A.\xC3K\xECb*vV\xBD\xBA\xA2>\xFE\x02\xF3\xED+\xA6\x80\x9D\x9E\xE1\xB7#1\xEA\x98Q\x9F\x9F/\xC2\xBB\xF9z8\xBF[A\xA9F\x86\xE7c\x95\xD51W\x1F\xC3/[\xB3\x0EvOo\xCF\xAEU\x9DWQ\xFC\x04Q\xAC\x9EAl\xB9\xA2Qc\x193z\n>'e\xC4\xC4\xBEh\"\xB7\xCD\xE7\x8F\xFF\x8B\x8E\xF5\xF9^ee\x8D\xB8r_\xCCW\x99\x1A&\n\xDAI\x92\x04\\q;I\xB8\xCA\xC0o\xF40\x9C\x1D\xF9\xBD\x18\xCC18\xCF\xA5\xE0\xCE8\\Ea6\x8Aq\t\xE3\x1D~?\x80\xD5x\x00\xC6\\c\x92\x8C\xA1.\xA1#\x05\x9F\\\xF7!\x98\xE1\xBA\x19^\xF3\xAB} \x9F\x00]|\xADB\x0E\xA2\r\x05\xB4\xA5Q2\x85\xBAG`6\x0E\xDF\x8A\x94\xE3+\"03\x06\xD7|<D\xF8iT\xD8K\xC0\xAA\f\xD6\x0E_\xC7\xB1\b\xA4\x19\x98\xAFYmD\x15C\x8B\x1E\xB2\x11\xB8J\x81\xFEay7\f\xBAc\xA8\x8F\xE3\x0F\"S|\x9C\xA8\xE2\x1C\x94H\xC3\xC8\x11\xD7\xCCuF\x00Q\x1C\xAF\xF8\xEC\x18|\x8F\x82\\\x1A\xF9\f\xA3\xCF\x02m\x02}\x18\x84\xFB\xC2\x17\x05\x11\x88H\bD\x11\xF8\x1E\x05\xDB\\b\bpe\x10\x05\xB7\x94\x91\x92A\xF4\x90\xFB\x13\xC5\xF5\xDC\xEA>\x9C\x15\xC8\x922\xCA|\\\xD3\x12\x92\\\n\x1C\x9C\xFF\xF1\xAA\xE54\xFA\x1F\x87\x17C\xFF30\x93\xC1\xD8\x84A\xBF\xA7\xD7\xCB\x9D!\xD40R\xCD\xA31\xF4/\x8C<$\xD1\xC2\x00\xDE\xE3,r>\xE3U\xC9T]T\"\xC8\x17\x8F\eG\x1EEKad$=\xAF'\x9E\xB6\xC6\xE8\xCC\x97\x1D\x9E\x85!\xF4OA\xA6\xE2(\x9D\x06\x1E\x15\x90\x8FUgD>\xC6\xD0\xD7\x88\xE4V\xE8\x14y/r\"^\xC7n\x04}\xE4\x91\xDD\x0FV\x15\x99Sa\xE4\xAE\xD1\vQ!\x1C\x7F\xCD\v\x11\x81\xB0\xFC\x8C\xD4qV\x8B~BF7R\x8Du\x12\xB3\xECVV\x0E`-*(\x15\xC6X\xA7\xAB,\fb\xFD\x8EH\xE4cu\x19\xE6\xC5qL\xE6g\xB2\x8A\xAC\x91_\xAF\x8E<\xB9;\xE9\x1DB\x97g\xBB1\x82Q\xCC\xA7\xB8D\x98\xAE\xB2\xF1\xC5zE\xEFR`_\xCB\xE1\xEF\x1D\xB7\xDA\xB7\ew\xEE\xFA\xD3c\xEDTZ\x7F\xFE\f\xD6\xF5\xDA\xFA\x93\x80\xE8\xC2C([j\x92\xAB\xCD\x8A\xFE,\xF6\xAC\xDAo\x9E\xFA3\xDC|;\x97\xF7+Y\x9C\xE9k\xA7_\xEF\xF4!z\xB7\xF8mT\x7F\xFA\xD5\xF0\x9C.\xCE\x82N\xF5T\"\xF6\x0F\xABz2\x99\xC6\xBB\xB5=]\xFC\x1A,\xA1D\xFD\xEF=\a\xED\n\xCF*rE\xB3.q\xBET\xF1\xB4\xC0\xAD9\xF3\xB0y\xBB\x1D\xAA\xF9\x17b\x19\xF7{ae\x1A\xC7\xAE<\x99p\xFF*R\x96\xCF?\xD5\xF4\xAB\xD8n\xFAU\xF5E1\xF0|\xF9\"\xFEm\x8CwY\xFE\xA62\x90a~\x9E\fI\xBD6\xF1~\x9F\xD58\xE1\f\x88\xA7_\xA5\xA6\xA8\xD7\xB2\x8Fk\xDBI\x9A\xCF\xA1\x9C\x83\xC9:\xE4\x9A\x8C\xB8x\x92\xC6m\xB6\x112\x88\x0F\xE3\xF8\xF3L\xFEL\xB4\xFA,\x94mrt\x9De\xF5\xA25\xBD9\xC4\xEE\xE0\xE9g\xA8\xAD\xAD\xB6x\\\xB7U&4W\x9F\xB9\xB6m\xBD\xED_[\xDB\x97\x7F:\xCB\x9A,\e\x00\x91\xB9\xB6\xAA\xE9%\xD5\x9EbV\xBEYK[\xDB\xA8n\x97\f\a\x9Fu\x82tA\xB7u\xB05i\xAB\xA6\xABkA\x96\xB7\xC1yX\x06\x0E\xDB\x93z\x90\xB9\x16S\xCD\x19V\xD6m\a\x16XY\x17\x1C6\xCCI\xB0\x92\x03\xD0\\\xD2-\xE8\xF2\xB9\xA6\x9A\xCBY\xA52\x88s\x01\xB7\x00\xDA\x81$\xDDt\x80\xE0\x00R\x12\xD8\f\xCA4\xA6:\x8E\x953T\xB0\a\f\xE6*%\xDDtU\x97\xE3\xC9\eE\xE0x\x13\xD7\x88\vX\xDA\xCA\xBB\xD3\xC0y`3\"\xB1\xF5\xB2mi\x95\x9C\x8Ej4\x03\x1C3\xB2\x15WG\f\r\v\x82\x10\xA5\\\xB1\xA2q$\xD3\x86[\xB0*.\x80)\x19\xD2\x10\x97\xB7\x05\x95\xA0\xB6\xE2\x80<w'\xC8J:z\x8D\xF1u\n\xC1:\eAn\xB3\xDB\xB2\x99\xA3C\x1C@\xDA\x00\xA8\xD2\xFD&\xD3\x1C\x1C\xA8-s\xA2]I\x1D\x1A\x9A.X\xA5[\x17\xF00\xE4+\xB6\t\x06u\\\xA8Y\xCC\xB1\x82\xCC\xA9d\x9F\xD0s.\x9F\x11\x1C\x17!%\xB9C9\xCB\xD4\f\xEE\x87\xB3\xB3\xAD-\x03\xB7\xD4\xACuLG\x0FD\x16!\x80j\x12\x98\x96\vap\xC4,\x8FJ\xB9\x96\x01\xE2\x1Es\n*8\x95\xD5%k\x00\x03\x92\\m\xF0\xD32!/lV\xB2l}^\xB7\x99;S\xD6\xF3*\x18\n\tP\x8DwK\xEA\f\xD7_\xB24#o\xF0DS\x8B.\xA4\x1E\f@\xA9\xAAi\xE8\xB9\xA0\x8E\xD7\x97j\x03\xAEJQ\xB5\xD1\x90\xA6;\xC6\xA4\x890&\x8B3\xE5\x82\xC3\x17\xF1\fUs\xA0\xC4\xE1+<<N\xB3%\x91q\x9A L-\xD6)hR\"\xD7yXj\x1A\x01\xA2Y\x9CaFC\xAA\x83K\xB6\xCE\xFF\xFF\f\x94\xE5\x03\x87\x93\xC9c\xE3\x95\x88\x0Ey\xA7\v\a\xA6-[sX\xA0Z\x8B\x01n\xDB\xBB\xC1\x02\xBCt\x03H\eD'.k&\xABC5q\xAD\x15\x88\x03w\xE2\x98eT\x81\xE9\xC7]\xA8\x1A\xA6\x96\xCBPbj\xB6\xA8\xF3\e\xC2\x7F\xD0\xDC\x14\x98\x82\xEA\xB2\x82\xEA\x80F\xDDl\xE4\x05\xCC\xD52\\c\x15S\x93\x80\x03\x8D}% <\xBC]d\x1D\xAB\xC8+\eC\xC7\x03\xA5\xB2\"\xEF P/\x9E`Y\xCDM\xA9\x93\xE0\x18\xD4\xA2iU\xFB\xC7\x9D'V\x83)hZ\x00Q/\xE69\xA8a\x85\r&\x13\x19\x96N\x0Ef\x0E\x84S\n\x8B\xA5\xD9h*9\x1E\x8B*Q\x16\b\xA7\xE1:\x10d\ab\x99\xE1\xE4X\x86\x81D*\x9C\xC8\x1Cb\xC9A\x16N\x1Cb\xFBb\x89h\x90)\aGSJ:\xCD\x92)\x16\e\x19\x8D\xC7\x14\x98\x8B%\"\xF1\xB1h,1\xC4\x06`]\"\x99a\xF1\xD8H,\x03J3I\\*U\xC5\x944W6\xA2\xA4\"\xC3p\x19\x1E\x88\xC5c\x99CA6\x18\xCB$\xB8\xCEAP\x1Af\xA3\xE1T&\x16\x19\x8B\x87Slt,5\x9AL+\xA0#\nj\x13\xB1\xC4`\n\xAC(#\n8\x01\x8A\"\xC9\xD1C\xA9\xD8\xD0p&\b\x8B20\x19d\x99T8\xAA\x8C\x84S\xFB\x82\x1Ca\x12\\N1\x14\t\x01J\xD0\xC1\x94q\xBE8=\x1C\x8E\xC7\xD9@,\x93\xCE\xA4\x94\xF0\b\x97\xE5\xEC\f%\x92#\x9C\xA3\xB1D4\x9C\x89%\x13l@\x01W\xC2\x03qE`\x03W\"\xF1pl$\xC8\xA2\xE1\x91\xF0\x90\x92\xAE\x19\xE1b\xD2\x9D\x1A\x1D|\xC1\x90\x92PR\xE1x\x90\xA5G\x95H\x8C\x0F\x80\xC7XJ\x89dP\x12\xB8\a&\xE2\b7\x92L\xA4\x95\xFDc0\x01r\x9E\t\b\xC8\xB0\x82&\xC0\x810\xFC\x17Ad\xE8~\x02\xDC\xE5z2\xC9T\xA6\n\xE5@,\xAD\x04Y8\x15Ks\b\x83\xA9$\xC0\xE5\xF1\x84\x15\xDC\xC71\xE0\x93\a/!\xF1\xF2\x18\xF1\xB9[\xB3\x03\xA4\xF8j\xE9`T\t\xC7Aa\x9A\xC3\xB8E\x16\xB2K9\x9E\xD3\xCB.\xCFmY\xDC\xA2=b+\x15\xFD3\x88Y+\x9A\x00\xA4\xF0\x90\t\x85+\xE6p\b\xF9\f\x95\x85;\x8F\xE8p\xB5\xE2\xE2[rP\xB6_\xDE> \xBBa7\x12\xEDW;\xA6C\x17tx+\x81\xFA\xB0x3\x996\x1C\xACt\xD8\x06K\x96\xDC\xF7\x1C\xB5\b\xC6`UU\n\xFA\xA5Z\x84eN\x15fcAy\eb\xD96`\xC9\xB4m\xB8\xD0L\x98Z\x81Y\xDBxJn\xC5\xB6\xDC\xAA\x9A=\xE0V\x9A\xF1\xDB\xBAS\x86\x9D\xCA8\xA6\x17gB k\xF3\xFD\f\x91\x18f\xDE\xB2K\xD2u\xA4/\xE7\xEE\xF4z\xA8\xCB&Q\xB9\x06\x8E[\xF6d\x88\xB5\xFD:\xFF*\xDA\x8D\xA7\xE0)xw\xE3\xC9Q\xC3\xE7q!|6Z\x86\xB9\xC6\xE7|\xB7\xFF7\xD4\xEEic\xCA\xE86\xA0\x1D\x1E\x0F\x95\v\xE5n\xD9\x93\xF9\xFF\x92\xF0?E\x8E\xF5\x94endstream\nendobj\n16 0 obj\n4599\nendobj\n14 0 obj\n<< /Type /Font\n/Subtype /CIDFontType2\n/BaseFont /DejaVuSansMono\n/CIDSystemInfo << /Registry (Adobe) /Ordering (Identity) /Supplement 0 >>\n/FontDescriptor 12 0 R\n/CIDToGIDMap /Identity\n/DW 597 >>\nendobj\n15 0 obj\n<< /Length 462 >>\nstream\n/CIDInit /ProcSet findresource begin\n12 dict begin\nbegincmap\n/CIDSystemInfo << /Registry (Adobe) /Ordering (UCS) /Supplement 0 >> def\n/CMapName /Adobe-Identity-UCS def\n/CMapType 2 def\n1 begincodespacerange\n<0000> <FFFF>\nendcodespacerange\n2 beginbfrange\n<0000> <0000> <0000>\n<0001> <000E> [<006D> <0069> <006E> <0061> <006C> <0020> <0070> <0064> <0066> <006F> <0063> <0075> <0065> <0074> ]\nendbfrange\nendcmap\nCMapName currentdict /CMap defineresource pop\nend\nend\nendstream\nendobj\n7 0 obj\n<< /Type /Font\n/Subtype /Type0\n/BaseFont /DejaVuSansMono\n/Encoding /Identity-H\n/DescendantFonts [14 0 R]\n/ToUnicode 15 0 R>>\nendobj\n3 0 obj\n<<\n/Type /Pages\n/Kids \n[\n6 0 R\n]\n/Count 1\n/ProcSet [/PDF /Text /ImageB /ImageC]\n>>\nendobj\nxref\n0 17\n0000000000 65535 f \n0000000009 00000 n \n0000000252 00000 n \n0000006862 00000 n \n0000000301 00000 n \n0000000396 00000 n \n0000000433 00000 n \n0000006722 00000 n \n0000000739 00000 n \n0000001004 00000 n \n0000000553 00000 n \n0000000719 00000 n \n0000001023 00000 n \n0000001287 00000 n \n0000005998 00000 n \n0000006209 00000 n \n0000005977 00000 n \ntrailer\n<<\n/Size 17\n/Info 1 0 R\n/Root 2 0 R\n>>\nstartxref\n6960\n%%EOF\n",
      headers: {}
    )

  # stub_request(:get, "http://www.mondialrelay.com/ww2/PDF/StickerMaker2.aspx?crc=04F2969A9D2159C9F72721F221E8F777&ens=ESMICOLE38&expedition=E001&format=10x15&lg=FR").
  #   with(
  #     headers: {
  #       'Accept'=>'*/*',
  #       'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  #       'User-Agent'=>'Ruby'
  #     }
  #   )
  #   .to_return(
  #     status: 200,
  #     body: "%PDF-1.3\r\n%\xE2\xE3\xCF\xD3\r\n\r\n1 0 obj\r\n<<\r\n/Type /Catalog\r\n/Outlines 2 0 R\r\n/Pages 3 0 R\r\n>>\r\nendobj\r\n\r\n2 0 obj\r\n<<\r\n/Type /Outlines\r\n/Count 0\r\n>>\r\nendobj\r\n\r\n3 0 obj\r\n<<\r\n/Type /Pages\r\n/Count 2\r\n/Kids [ 4 0 R 6 0 R ] \r\n>>\r\nendobj\r\n\r\n4 0 obj\r\n<<\r\n/Type /Page\r\n/Parent 3 0 R\r\n/Resources <<\r\n/Font <<\r\n/F1 9 0 R \r\n>>\r\n/ProcSet 8 0 R\r\n>>\r\n/MediaBox [0 0 612.0000 792.0000]\r\n/Contents 5 0 R\r\n>>\r\nendobj\r\n\r\n5 0 obj\r\n<< /Length 1074 >>\r\nstream\r\n2 J\r\nBT\r\n0 0 0 rg\r\n/F1 0027 Tf\r\n57.3750 722.2800 Td\r\n( A Simple PDF File ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 688.6080 Td\r\n( This is a small demonstration .pdf file - ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 664.7040 Td\r\n( just for use in the Virtual Mechanics tutorials. More text. And more ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 652.7520 Td\r\n( text. And more text. And more text. And more text. ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 628.8480 Td\r\n( And more text. And more text. And more text. And more text. And more ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 616.8960 Td\r\n( text. And more text. Boring, zzzzz. And more text. And more text. And ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 604.9440 Td\r\n( more text. And more text. And more text. And more text. And more text. ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 592.9920 Td\r\n( And more text. And more text. ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 569.0880 Td\r\n( And more text. And more text. And more text. And more text. And more ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 557.1360 Td\r\n( text. And more text. And more text. Even more. Continued on page 2 ...) Tj\r\nET\r\nendstream\r\nendobj\r\n\r\n6 0 obj\r\n<<\r\n/Type /Page\r\n/Parent 3 0 R\r\n/Resources <<\r\n/Font <<\r\n/F1 9 0 R \r\n>>\r\n/ProcSet 8 0 R\r\n>>\r\n/MediaBox [0 0 612.0000 792.0000]\r\n/Contents 7 0 R\r\n>>\r\nendobj\r\n\r\n7 0 obj\r\n<< /Length 676 >>\r\nstream\r\n2 J\r\nBT\r\n0 0 0 rg\r\n/F1 0027 Tf\r\n57.3750 722.2800 Td\r\n( Simple PDF File 2 ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 688.6080 Td\r\n( ...continued from page 1. Yet more text. And more text. And more text. ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 676.6560 Td\r\n( And more text. And more text. And more text. And more text. And more ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 664.7040 Td\r\n( text. Oh, how boring typing this stuff. But not as boring as watching ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 652.7520 Td\r\n( paint dry. And more text. And more text. And more text. And more text. ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 640.8000 Td\r\n( Boring.  More, a little more text. The end, and just as well. ) Tj\r\nET\r\nendstream\r\nendobj\r\n\r\n8 0 obj\r\n[/PDF /Text]\r\nendobj\r\n\r\n9 0 obj\r\n<<\r\n/Type /Font\r\n/Subtype /Type1\r\n/Name /F1\r\n/BaseFont /Helvetica\r\n/Encoding /WinAnsiEncoding\r\n>>\r\nendobj\r\n\r\n10 0 obj\r\n<<\r\n/Creator (Rave \\(http://www.nevrona.com/rave\\))\r\n/Producer (Nevrona Designs)\r\n/CreationDate (D:20060301072826)\r\n>>\r\nendobj\r\n\r\nxref\r\n0 11\r\n0000000000 65535 f\r\n0000000019 00000 n\r\n0000000093 00000 n\r\n0000000147 00000 n\r\n0000000222 00000 n\r\n0000000390 00000 n\r\n0000001522 00000 n\r\n0000001690 00000 n\r\n0000002423 00000 n\r\n0000002456 00000 n\r\n0000002574 00000 n\r\n\r\ntrailer\r\n<<\r\n/Size 11\r\n/Root 1 0 R\r\n/Info 10 0 R\r\n>>\r\n\r\nstartxref\r\n2714\r\n%%EOF\r\n",
  #     headers: {}
  #   )

  # Error
  # ---

  savon.expects(:wsi3_get_etiquettes).with(message: {
    "Enseigne" => "test",
    "Expeditions" => "E000",
    "Langue" => "FR",
    "Security" => "295415E8DFCC359C24F9BE9BC3E3966B"
  }).returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI3_GetEtiquettesResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI3_GetEtiquettesResult>
            <STAT>24</STAT>
            <URL_PDF_A4 />
            <URL_PDF_A5 />
            <URL_PDF_10x15 />
          </WSI3_GetEtiquettesResult>
        </WSI3_GetEtiquettesResponse>
      </soap:Body>
    </soap:Envelope>
  ))
end

def register_mondial_relay_get_labels_stubs

  # Success
  # ---

  savon.expects(:wsi3_get_etiquettes).with(message: {
    "Enseigne" => "test",
    "Expeditions" => "E001;E002",
    "Langue" => "FR",
    "Security" => "D47B3C68F274CF69D05C57A2B5B532A0"
  }).returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI3_GetEtiquettesResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI3_GetEtiquettesResult>
            <STAT>0</STAT>
            <URL_PDF_A4>/ww2/PDF/StickerMaker2.aspx?ens=test11&amp;expedition=E001;E002&amp;lg=FR&amp;format=A4&amp;crc=585C8413D5BC74EF6C7B2A620CED8366</URL_PDF_A4>
            <URL_PDF_A5>/ww2/PDF/StickerMaker2.aspx?ens=test11&amp;expedition=E001;E002&amp;lg=FR&amp;format=A5&amp;crc=585C8413D5BC74EF6C7B2A620CED8366</URL_PDF_A5>
            <URL_PDF_10x15>/ww2/PDF/StickerMaker2.aspx?ens=test11&amp;expedition=E001;E002&amp;lg=FR&amp;format=10x15&amp;crc=585C8413D5BC74EF6C7B2A620CED8366</URL_PDF_10x15>
          </WSI3_GetEtiquettesResult>
        </WSI3_GetEtiquettesResponse>
      </soap:Body>
    </soap:Envelope>
  ))

  stub_request(:get, "http://www.mondialrelay.com/ww2/PDF/StickerMaker2.aspx?ens=test11&expedition=E001;E002&lg=FR&format=10x15&crc=585C8413D5BC74EF6C7B2A620CED8366").
    with(
      headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Ruby'
      }
    )
    .to_return(
      status: 200,
      body: "%PDF-1.3\r\n%\xE2\xE3\xCF\xD3\r\n\r\n1 0 obj\r\n<<\r\n/Type /Catalog\r\n/Outlines 2 0 R\r\n/Pages 3 0 R\r\n>>\r\nendobj\r\n\r\n2 0 obj\r\n<<\r\n/Type /Outlines\r\n/Count 0\r\n>>\r\nendobj\r\n\r\n3 0 obj\r\n<<\r\n/Type /Pages\r\n/Count 2\r\n/Kids [ 4 0 R 6 0 R ] \r\n>>\r\nendobj\r\n\r\n4 0 obj\r\n<<\r\n/Type /Page\r\n/Parent 3 0 R\r\n/Resources <<\r\n/Font <<\r\n/F1 9 0 R \r\n>>\r\n/ProcSet 8 0 R\r\n>>\r\n/MediaBox [0 0 612.0000 792.0000]\r\n/Contents 5 0 R\r\n>>\r\nendobj\r\n\r\n5 0 obj\r\n<< /Length 1074 >>\r\nstream\r\n2 J\r\nBT\r\n0 0 0 rg\r\n/F1 0027 Tf\r\n57.3750 722.2800 Td\r\n( A Simple PDF File ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 688.6080 Td\r\n( This is a small demonstration .pdf file - ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 664.7040 Td\r\n( just for use in the Virtual Mechanics tutorials. More text. And more ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 652.7520 Td\r\n( text. And more text. And more text. And more text. ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 628.8480 Td\r\n( And more text. And more text. And more text. And more text. And more ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 616.8960 Td\r\n( text. And more text. Boring, zzzzz. And more text. And more text. And ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 604.9440 Td\r\n( more text. And more text. And more text. And more text. And more text. ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 592.9920 Td\r\n( And more text. And more text. ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 569.0880 Td\r\n( And more text. And more text. And more text. And more text. And more ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 557.1360 Td\r\n( text. And more text. And more text. Even more. Continued on page 2 ...) Tj\r\nET\r\nendstream\r\nendobj\r\n\r\n6 0 obj\r\n<<\r\n/Type /Page\r\n/Parent 3 0 R\r\n/Resources <<\r\n/Font <<\r\n/F1 9 0 R \r\n>>\r\n/ProcSet 8 0 R\r\n>>\r\n/MediaBox [0 0 612.0000 792.0000]\r\n/Contents 7 0 R\r\n>>\r\nendobj\r\n\r\n7 0 obj\r\n<< /Length 676 >>\r\nstream\r\n2 J\r\nBT\r\n0 0 0 rg\r\n/F1 0027 Tf\r\n57.3750 722.2800 Td\r\n( Simple PDF File 2 ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 688.6080 Td\r\n( ...continued from page 1. Yet more text. And more text. And more text. ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 676.6560 Td\r\n( And more text. And more text. And more text. And more text. And more ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 664.7040 Td\r\n( text. Oh, how boring typing this stuff. But not as boring as watching ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 652.7520 Td\r\n( paint dry. And more text. And more text. And more text. And more text. ) Tj\r\nET\r\nBT\r\n/F1 0010 Tf\r\n69.2500 640.8000 Td\r\n( Boring.  More, a little more text. The end, and just as well. ) Tj\r\nET\r\nendstream\r\nendobj\r\n\r\n8 0 obj\r\n[/PDF /Text]\r\nendobj\r\n\r\n9 0 obj\r\n<<\r\n/Type /Font\r\n/Subtype /Type1\r\n/Name /F1\r\n/BaseFont /Helvetica\r\n/Encoding /WinAnsiEncoding\r\n>>\r\nendobj\r\n\r\n10 0 obj\r\n<<\r\n/Creator (Rave \\(http://www.nevrona.com/rave\\))\r\n/Producer (Nevrona Designs)\r\n/CreationDate (D:20060301072826)\r\n>>\r\nendobj\r\n\r\nxref\r\n0 11\r\n0000000000 65535 f\r\n0000000019 00000 n\r\n0000000093 00000 n\r\n0000000147 00000 n\r\n0000000222 00000 n\r\n0000000390 00000 n\r\n0000001522 00000 n\r\n0000001690 00000 n\r\n0000002423 00000 n\r\n0000002456 00000 n\r\n0000002574 00000 n\r\n\r\ntrailer\r\n<<\r\n/Size 11\r\n/Root 1 0 R\r\n/Info 10 0 R\r\n>>\r\n\r\nstartxref\r\n2714\r\n%%EOF\r\n",
      headers: {}
    )

  # Error
  # ---

  savon.expects(:wsi3_get_etiquettes).with(message: {
    "Enseigne" => "test",
    "Expeditions" => "E001;E000",
    "Langue" => "FR",
    "Security" => "2DF1275F8E242408F41ABD6F8F36F3FD"
  }).returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI3_GetEtiquettesResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI3_GetEtiquettesResult>
            <STAT>24</STAT>
            <URL_PDF_A4 />
            <URL_PDF_A5 />
            <URL_PDF_10x15 />
          </WSI3_GetEtiquettesResult>
        </WSI3_GetEtiquettesResponse>
      </soap:Body>
    </soap:Envelope>
  ))
end

def register_mondial_relay_shipment_info_stubs

  # Success
  # ---

  savon.expects(:wsi2_tracing_colis_detaille).with(message: {
    "Enseigne" => "test",
    "Expedition" => "E001",
    "Langue" => "FR",
    "Security" => "B351449343E158B37FCD6AE7394581FD"
  }).returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI2_TracingColisDetailleResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI2_TracingColisDetailleResult>
            <STAT>81</STAT>
            <Libelle01>COLIS PRIS EN CHARGE</Libelle01>
            <Relais_Libelle>EYBENS</Relais_Libelle>
            <Relais_Num>048607</Relais_Num>
            <Libelle02 />
            <Tracing>
              <ret_WSI2_sub_TracingColisDetaille>
                <Libelle>RÉCEPTION DES DONNÉES</Libelle>
                <Date>#{Date.yesterday.strftime('%d/%m/%y')}</Date>
                <Heure>10:10</Heure>
                <Emplacement />
                <Relais_Num />
                <Relais_Pays />
              </ret_WSI2_sub_TracingColisDetaille>
              <ret_WSI2_sub_TracingColisDetaille>
                <Libelle>PRISE EN CHARGE EN AGENCE</Libelle>
                <Date>#{Date.current.strftime('%d/%m/%y')}</Date>
                <Heure>11:11</Heure>
                <Emplacement>ESPAGNE</Emplacement>
                <Relais_Num />
                <Relais_Pays />
              </ret_WSI2_sub_TracingColisDetaille>
              <ret_WSI2_sub_TracingColisDetaille>
                <Libelle />
                <Date />
                <Heure />
                <Emplacement />
                <Relais_Num />
                <Relais_Pays />
              </ret_WSI2_sub_TracingColisDetaille>
              <ret_WSI2_sub_TracingColisDetaille>
                <Libelle />
                <Date />
                <Heure />
                <Emplacement />
                <Relais_Num />
                <Relais_Pays />
              </ret_WSI2_sub_TracingColisDetaille>
              <ret_WSI2_sub_TracingColisDetaille>
                <Libelle />
                <Date />
                <Heure />
                <Emplacement />
                <Relais_Num />
                <Relais_Pays />
              </ret_WSI2_sub_TracingColisDetaille>
              <ret_WSI2_sub_TracingColisDetaille>
                <Libelle />
                <Date />
                <Heure />
                <Emplacement />
                <Relais_Num />
                <Relais_Pays />
              </ret_WSI2_sub_TracingColisDetaille>
              <ret_WSI2_sub_TracingColisDetaille>
                <Libelle />
                <Date />
                <Heure />
                <Emplacement />
                <Relais_Num />
                <Relais_Pays />
              </ret_WSI2_sub_TracingColisDetaille>
              <ret_WSI2_sub_TracingColisDetaille>
                <Libelle />
                <Date />
                <Heure />
                <Emplacement />
                <Relais_Num />
                <Relais_Pays />
              </ret_WSI2_sub_TracingColisDetaille>
              <ret_WSI2_sub_TracingColisDetaille>
                <Libelle />
                <Date />
                <Heure />
                <Emplacement />
                <Relais_Num />
                <Relais_Pays />
              </ret_WSI2_sub_TracingColisDetaille>
              <ret_WSI2_sub_TracingColisDetaille>
                <Libelle />
                <Date />
                <Heure />
                <Emplacement />
                <Relais_Num />
                <Relais_Pays />
              </ret_WSI2_sub_TracingColisDetaille>
              <ret_WSI2_sub_TracingColisDetaille>
                <Libelle />
                <Date />
                <Heure />
                <Emplacement />
                <Relais_Num />
                <Relais_Pays />
              </ret_WSI2_sub_TracingColisDetaille>
              <ret_WSI2_sub_TracingColisDetaille>
                <Libelle />
                <Date />
                <Heure />
                <Emplacement />
                <Relais_Num />
                <Relais_Pays />
              </ret_WSI2_sub_TracingColisDetaille>
              <ret_WSI2_sub_TracingColisDetaille>
                <Libelle />
                <Date />
                <Heure />
                <Emplacement />
                <Relais_Num />
                <Relais_Pays />
              </ret_WSI2_sub_TracingColisDetaille>
              <ret_WSI2_sub_TracingColisDetaille>
                <Libelle />
                <Date />
                <Heure />
                <Emplacement />
                <Relais_Num />
                <Relais_Pays />
              </ret_WSI2_sub_TracingColisDetaille>
              <ret_WSI2_sub_TracingColisDetaille>
                <Libelle />
                <Date />
                <Heure />
                <Emplacement />
                <Relais_Num />
                <Relais_Pays />
              </ret_WSI2_sub_TracingColisDetaille>
            </Tracing>
          </WSI2_TracingColisDetailleResult>
        </WSI2_TracingColisDetailleResponse>
      </soap:Body>
    </soap:Envelope>
  ))

  # Error
  # ---

  savon.expects(:wsi2_tracing_colis_detaille).with(message: {
    "Enseigne" => "test",
    "Expedition" => "E000",
    "Langue" => "FR",
    "Security" => "295415E8DFCC359C24F9BE9BC3E3966B"
  }).returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI2_TracingColisDetailleResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI2_TracingColisDetailleResult>
            <STAT>24</STAT>
            <Libelle01 />
            <Relais_Libelle />
            <Relais_Num />
            <Libelle02 />
          </WSI2_TracingColisDetailleResult>
        </WSI2_TracingColisDetailleResponse>
      </soap:Body>
    </soap:Envelope>
  ))
end
