module Deliveries
  module Couriers
    class CorreosExpress
      module Pickups
        class Create
          module Defaults
            PARAMS = {
              solicitante: "",
              password: "",
              canalEntrada: "",
              refRecogida: "",
              fechaRecogida: "", #ddmmyyyy
              horaDesde1: "09:00",
              horaDesde2: "",
              horaHasta1: "17:00",
              horaHasta2: "",
              clienteRecogida: "",
              codRemit: "",
              nomRemit: "",
              nifRemit: "",
              dirRecog: "",
              poblRecog: "",
              cpRecog: "",
              contRecog: "",
              tlfnoRecog: "",
              oTlfnRecog: "",
              emailRecog: "",
              observ: "",
              tipoServ: "",
              codDest: "",
              nomDest: "",
              nifDest: "",
              dirDest: "",
              pobDest: "",
              cpDest: "",
              paisDest: "",
              cpiDest: "",
              contactoDest: "",
              tlfnoDest: "",
              emailDest: "",
              nEnvio: "",
              refEnvio: "",
              producto: "63",
              kilos: "",
              bultos: "",
              volumen: "",
              tipoPortes: "",
              importReembol: "",
              valDeclMerc: "",
              infTec: "",
              nSerie: "",
              modelo: "",
              latente: "0"
            }.freeze
          end
        end
      end
    end
  end
end
