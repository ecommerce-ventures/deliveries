module Deliveries
  module Couriers
    class CorreosExpress < Deliveries::Courier
      module Labels
        class Generate
          attr_accessor :tracking_codes

          def initialize(tracking_codes:)
            self.tracking_codes = tracking_codes.respond_to?(:each) ? tracking_codes : [tracking_codes]
          end

          def execute
            auth = {
              username: Deliveries::Couriers::CorreosExpress.config(:correos_express_user),
              password: Deliveries::Couriers::CorreosExpress.config(:correos_express_password)
            }

            # Load the cod_rte from prod because the dev api does not work
            if Deliveries.test?
              cod_rte = YAML.load_file('config/deliveries/correos_express.yml')['production']['cod_rte']
            else
              cod_rte = Deliveries::Couriers::CorreosExpress.config(:cod_rte)
            end

            decoded_labels = []
            tracking_codes.each do |tracking_code|
              params = {
                keyCli: cod_rte,
                nenvio: tracking_code,
                tipo: "1" # "1" - pdf, "2" - zpl image
              }.to_json

              headers = { "Content-Type" => "application/json" }
              response = HTTParty.post(api_endpoint, basic_auth: auth, body: params, headers: headers)
              parsed_response = JSON.parse(response.body)
              if parsed_response.dig('codErr') == 0
                if parsed_response["listaEtiquetas"].any?
                  parsed_response["listaEtiquetas"].each do |encoded_label|
                    decoded_labels << Base64.decode64(encoded_label)
                  end
                end
              else
                raise Deliveries::APIError.new(
                  parsed_response.dig('desErr'),
                  parsed_response.dig('codErr')
                )
              end
            end

            file = StringIO.new

            Deliveries::Label.generate_merged_pdf(decoded_labels).write(file)
            file.string.force_encoding('binary')
          end

          private

          def api_endpoint
            CorreosExpress::LABELS_ENDPOINT_LIVE
          end
        end
      end
    end
  end
end
