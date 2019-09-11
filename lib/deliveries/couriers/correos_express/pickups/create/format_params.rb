module Deliveries
  module Couriers
    module CorreosExpress
      module Pickups
        class Create
          class FormatParams
            attr_accessor :sender, :receiver, :parcels, :reference_code,
                          :pickup_date, :remarks, :time_interval

            def initialize(sender:, receiver:, parcels:, reference_code:,
                           pickup_date:, remarks:, time_interval: nil)
              self.sender = sender
              self.receiver = receiver
              self.parcels = parcels
              self.reference_code = reference_code
              self.pickup_date = pickup_date
              self.remarks = remarks
              self.time_interval = time_interval
            end

            def execute
              postcode = format_postcode(sender.postcode, sender.country)
              params = {
                solicitante: CorreosExpress.config(:client_code),
                refRecogida: reference_code,
                fechaRecogida: pickup_date&.strftime("%d%m%Y") || '',
                clienteRecogida: CorreosExpress.config(:pickup_receiver_code),
                codRemit: "",
                nomRemit: sender.name,
                nifRemit: "",
                dirRecog: sender.street,
                poblRecog: sender.city,
                cpRecog: postcode,
                contRecog: sender.name,
                tlfnoRecog: sender.phone,
                emailRecog: sender.email,
                codDest: CorreosExpress.config(:pickup_receiver_code),
                nomDest: receiver.name,
                dirDest: receiver.street,
                pobDest: receiver.city,
                cpDest: receiver.postcode,
                paisDest: receiver.country,
                contactoDest: receiver.name,
                tlfnoDest: receiver.phone,
                emailDest: receiver.email,
                bultos: parcels.to_s
              }

              unless CorreosExpress.test?
                custom_product = CorreosExpress.config("countries.#{sender.country.to_s.downcase}.product")
                params[:producto] = custom_product if custom_product
              end

              defaults = Defaults::PARAMS

              defaults = defaults.merge(params)

              if time_interval
                defaults[:horaDesde1] = '%02d:00' % time_interval.first
                defaults[:horaHasta1] = '%02d:00' % time_interval.last
              else
                # Try to set cutoff time for the sender postal code.
                begin
                  cutoff_time = CutoffTime.new(country: sender.country, postcode: postcode).execute
                  # Set only when cuttoff time is less than 19:00 (the default cutoff time in correos express)
                  defaults[:horaHasta1] = cutoff_time if cutoff_time.to_i < 19
                rescue Deliveries::Error
                end
              end

              defaults.to_json
            end

            private

            def format_postcode(postcode, country)
              if country.to_sym.downcase == :pt
                postcode&.split('-')&.first
              else
                postcode
              end
            end
          end
        end
      end
    end
  end
end
