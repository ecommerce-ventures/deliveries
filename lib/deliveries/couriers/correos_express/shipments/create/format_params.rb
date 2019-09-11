module Deliveries
  module Couriers
    module CorreosExpress
      module Shipments
        class Create
          class FormatParams
            attr_accessor :sender, :receiver, :collection_point, :shipment_date,
                          :parcels, :reference_code, :remarks

            NATIONAL_COUNTRY = :es

            def initialize(sender:, receiver:, collection_point:, parcels:,
                           reference_code:, shipment_date:, remarks:)
              self.sender = sender
              self.receiver = receiver
              self.collection_point = collection_point
              self.parcels = parcels
              self.reference_code = reference_code
              self.shipment_date = shipment_date
              self.remarks = remarks
            end

            def execute
              params = {
                solicitante: CorreosExpress.config(:client_code),
                codRte: CorreosExpress.config(:shipment_sender_code),
                ref: reference_code,
                fecha: format_date(shipment_date),
                nomRte: sender.name,
                dirRte: sender.street,
                pobRte: sender.city,
                paisISORte: sender.country.to_s,
                contacRte: sender.name,
                telefRte: sender.phone,
                emailRte: sender.email,
                nomDest: receiver.name,
                dirDest: receiver.street,
                pobDest: receiver.city,
                paisISODest: receiver.country.to_s,
                contacDest: receiver.name,
                telefDest: receiver.phone,
                emailDest: receiver.email,
                numBultos: parcels.to_s,
                observac: remarks&.truncate(50, omission: '')
              }

              if collection_point.present?
                params = params.merge(
                  codDirecDestino: collection_point.point_id
                )
              end

              params = if national_country?(sender.country)
                         params.merge(codPosNacRte: format_postcode(sender.postcode, sender.country))
                       else
                         params.merge(codPosIntRte: format_postcode(sender.postcode, sender.country))
                       end

              params = if national_country?(receiver.country)
                         params.merge(codPosNacDest: format_postcode(receiver.postcode, receiver.country))
                       else
                         params.merge(codPosIntDest: format_postcode(receiver.postcode, receiver.country))
                       end

              unless CorreosExpress.test?
                custom_product = CorreosExpress.config("countries.#{receiver.country.to_s.downcase}.product")
                params[:producto] = custom_product if custom_product
              end

              defaults = Defaults::PARAMS

              defaults.merge(params).to_json
            end

            private

            def format_date(date)
              raise Deliveries::Error if date.blank?

              date.strftime("%d%m%Y")
            end

            def format_postcode(postcode, country)
              if country.to_sym.downcase == :pt
                postcode&.split('-')&.first
              else
                postcode
              end
            end

            def national_country?(country)
              country.to_sym.downcase == NATIONAL_COUNTRY
            end
          end
        end
      end
    end
  end
end
