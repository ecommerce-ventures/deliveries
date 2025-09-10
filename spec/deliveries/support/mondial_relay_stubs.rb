def register_mondial_relay_wsdl
  wsdl = (File.open(File.expand_path("../..", __dir__) + '/fixtures/files/mondial_relay_wsdl.xml')).read

  stub_request(:get, 'https://api.mondialrelay.com/Web_Services.asmx?WSDL')
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
    "NACE" => "",
    "NombreResultats" => "30"
  }
  message['Security'] = Deliveries::Couriers::MondialRelay.calculate_security_param message

  savon.expects(:wsi4_point_relais_recherche).with(message: message)
    .returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI4_PointRelais_RechercheResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI4_PointRelais_RechercheResult>
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
                  <string>0000</string>
                  <string>2359</string>
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
          </WSI4_PointRelais_RechercheResult>
        </WSI4_PointRelais_RechercheResponse>
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
    "NACE" => "",
    "NombreResultats" => "30"
  }
  message['Security'] = Deliveries::Couriers::MondialRelay.calculate_security_param message

  savon.expects(:wsi4_point_relais_recherche).with(message: message).returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI4_PointRelais_RechercheResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI4_PointRelais_RechercheResult>
            <STAT>0</STAT>
            <PointsRelais />
          </WSI4_PointRelais_RechercheResult>
        </WSI4_PointRelais_RechercheResponse>
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
    "NACE" => "",
    "NombreResultats" => "30"
  }
  message['Security'] = Deliveries::Couriers::MondialRelay.calculate_security_param message

  savon.expects(:wsi4_point_relais_recherche).with(message: message).returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI4_PointRelais_RechercheResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI4_PointRelais_RechercheResult>
            <STAT>40</STAT>
            <PointsRelais />
          </WSI4_PointRelais_RechercheResult>
        </WSI4_PointRelais_RechercheResponse>
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
    "NACE" => "",
    "NombreResultats" => "1"
  }
  message['Security'] = Deliveries::Couriers::MondialRelay.calculate_security_param message

  savon.expects(:wsi4_point_relais_recherche).with(message: message)
    .returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI4_PointRelais_RechercheResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI4_PointRelais_RechercheResult>
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
                <Information>LOCKER</Information>
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
          </WSI4_PointRelais_RechercheResult>
        </WSI4_PointRelais_RechercheResponse>
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
    "NACE" => "",
    "NombreResultats" => "1"
  }
  message['Security'] = Deliveries::Couriers::MondialRelay.calculate_security_param message

  savon.expects(:wsi4_point_relais_recherche).with(message: message).returns(%(
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope
      xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <soap:Body>
        <WSI4_PointRelais_RechercheResponse
          xmlns="http://www.mondialrelay.fr/webservice/">
          <WSI4_PointRelais_RechercheResult>
            <STAT>70</STAT>
            <PointsRelais />
          </WSI4_PointRelais_RechercheResult>
        </WSI4_PointRelais_RechercheResponse>
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
    "Security" => "1057DDDAE337C2E00627E9B3D8C5F39D"
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
