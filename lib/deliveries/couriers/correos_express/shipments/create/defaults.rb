module Deliveries
  module Couriers
    module CorreosExpress
      module Shipments
        class Create
          module Defaults
            PARAMS = {
              solicitante: "1",
              canalEntrada: "",
              numEnvio: "",
              ref: "",
              fecha: "", # DDMMYYYY
              codRte: "",
              nomRte: "",
              nifRte: "",
              dirRte: "",
              pobRte: "",
              codPosNacRte: "",
              paisISORte: "",
              codPosIntRte: "",
              contacRte: "",
              telefRte: "",
              emailRte: "",
              codDest: "",
              nomDest: "",
              nifDest: "",
              dirDest: "",
              pobDest: "",
              codPosNacDest: "",
              paisISODest: "",
              codPosIntDest: "",
              contacDest: "",
              telefDest: "",
              emailDest: "",
              contacOtrs: "",
              telefOtrs: "",
              emailOtrs: "",
              observac: "",
              numBultos: "1",
              kilos: "1",
              volumen: "",
              alto: "",
              largo: "",
              ancho: "",
              producto: "63",
              portes: "P",
              reembolso: "",
              entrSabado: "",
              seguro: "",
              numEnvioVuelta: "",
              listaBultos: [
                {
                  alto: "",
                  ancho: "",
                  codBultoCli: "",
                  codUnico: "",
                  descripcion: "",
                  kilos: "",
                  largo: "",
                  observaciones: "",
                  orden: "1",
                  referencia: "",
                  volumen: ""
                }
              ],
              codDirecDestino: "",
              password: "",
              listaInformacionAdicional: [
                {
                  tipoEtiqueta: "1", # 1 PDF, 2 ZPL
                  etiquetaPDF: ""
                }
              ]
            }.freeze
          end
        end
      end
    end
  end
end
