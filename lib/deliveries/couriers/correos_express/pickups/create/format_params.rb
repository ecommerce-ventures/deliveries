module Deliveries
  module Couriers
    class CorreosExpress < Deliveries::Courier
      module Pickups
        class Create
          class FormatParams
            attr_accessor :sender, :receiver, :parcels, :reference_code,
                          :pickup_date, :remarks

            def initialize(sender:, receiver:, parcels:, reference_code:,
                           pickup_date:, remarks:)
              self.sender = sender
              self.receiver = receiver
              self.parcels = parcels
              self.reference_code = reference_code
              self.pickup_date = pickup_date
              self.remarks = remarks
            end

            def execute
              params = {
                solicitante: Deliveries::Couriers::CorreosExpress.config(:solicitante),
                refRecogida: reference_code,
                fechaRecogida: pickup_date.strftime("%d%m%Y"),
                clienteRecogida: Deliveries::Couriers::CorreosExpress.config(:cod_rte),
                codRemit: "",
                nomRemit: sender.name,
                nifRemit: "",
                dirRecog: sender.street,
                poblRecog: sender.city,
                cpRecog: sender.postcode,
                contRecog: sender.name,
                tlfnoRecog: sender.phone
              }

              defaults = Defaults::PARAMS

              defaults = defaults.merge(params)

              # Only used in this api
              if Deliveries.courier('correos_express').test?
                defaults = defaults.merge(
                  solicitante: 'solicitante2',
                  clienteRecogida: '555550111'
                )
              end

              defaults.to_json
            end
          end
        end
      end
    end
  end
end
