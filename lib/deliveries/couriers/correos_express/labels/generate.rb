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
              username: Deliveries::Couriers::CorreosExpress.class_variable_get(:@@config).correos_express_user,
              password: Deliveries::Couriers::CorreosExpress.class_variable_get(:@@config).correos_express_password
            }

            # Load the cod_rte from prod because the dev api does not work
            if Deliveries.test?
              cod_rte = YAML.load_file('config/deliveries/correos_express.yml')['production']['cod_rte']
            else
              cod_rte = Deliveries::Couriers::CorreosExpress.class_variable_get(:@@cod_rte)
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
              if response.dig('codErr') == 0
                if response["listaEtiquetas"].any?
                  response["listaEtiquetas"].each do |encoded_label|
                    decoded_labels << Base64.decode64(encoded_label)
                  end
                end
              else
                raise Deliveries::APIError.new(
                  response.dig('desErr'),
                  response.dig('codErr')
                )
              end
            end

            file = StringIO.new

            generate_merged_pdf(decoded_labels).write(file)
            file.string.force_encoding('binary')
          end

          private

          def api_endpoint
            CorreosExpress::LABELS_ENDPOINT_LIVE
          end

          # Creates temporary pdfs for each label and then joins them. We also ensure
          # that temp files are deleted
          def generate_merged_pdf(decoded_labels)
            target = HexaPDF::Document.new
            decoded_labels.each_with_index do |decoded_label, i|
              file = Tempfile.new(["label-#{i}", 'pdf'])
              begin
                file.write(decoded_label.force_encoding('UTF-8'))
                pdf = HexaPDF::Document.open(file)

                pdf.pages.each { |page| target.pages << target.import(page) }
              ensure
                file.close
                file.unlink
              end
            end

            target
          end
        end
      end
    end
  end
end
