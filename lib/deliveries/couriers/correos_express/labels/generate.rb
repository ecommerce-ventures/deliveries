module Deliveries
  module Couriers
    module CorreosExpress
      module Labels
        class Generate
          include HTTParty
          persistent_connection_adapter

          attr_accessor :tracking_codes

          def initialize(tracking_codes:)
            self.tracking_codes = tracking_codes.respond_to?(:each) ? tracking_codes : [tracking_codes]
          end

          def execute
            auth = {
              username: CorreosExpress.config(:username),
              password: CorreosExpress.config(:password)
            }
            decoded_labels = []
            tracking_codes.each do |tracking_code|
              params = {
                keyCli: CorreosExpress.config(:shipment_sender_code),
                nenvio: tracking_code,
                tipo: "1" # "1" - pdf, "2" - zpl image
              }.to_json

              headers = { "Content-Type" => "application/json" }
              response = self.class.post(
                api_endpoint,
                basic_auth: auth,
                body: params,
                headers: headers,
                debug_output: Deliveries.debug ? Deliveries.logger : nil
              )
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
            if CorreosExpress.live?
              CorreosExpress::LABELS_ENDPOINT_LIVE
            else
              CorreosExpress::LABELS_ENDPOINT_TEST
            end
          end
        end
      end
    end
  end
end