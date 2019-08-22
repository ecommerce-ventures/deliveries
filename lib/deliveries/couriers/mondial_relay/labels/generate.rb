module Deliveries
  module Couriers
    class MondialRelay < Deliveries::Courier
      module Labels
        class Generate
          attr_accessor :tracking_codes, :language

          def initialize(tracking_codes:, language:)
            self.tracking_codes = tracking_codes
            self.language = language.to_s.upcase
          end

          def execute
            params = {
              'Enseigne' => Deliveries::Couriers::MondialRelay.config(:mondial_relay_merchant),
              'Expeditions' => tracking_codes,
              'Langue' => language
            }

            # Calculate security parameters.
            params['Security'] = Deliveries::Couriers::MondialRelay.calculate_security_param params

            response = MondialRelay.api_client.call :wsi2_get_etiquettes, message: params
            if (response_result = response.body[:wsi2_get_etiquettes_response][:wsi2_get_etiquettes_result]) &&
               response_result[:stat] == '0'
              # Get path for A4 format.
              url_path = response.body[:wsi2_get_etiquettes_response][:wsi2_get_etiquettes_result][:url_pdf_a4]
              # Build URL for 10x15 format.
              'http://www.mondialrelay.com' + url_path.gsub('format=A4', 'format=10x15')
            else
              raise Deliveries::APIError.new(
                Deliveries.courier('mondial_relay')::StatusCodes.message_for(response_result[:stat].to_i),
                response_result[:stat]
              )
            end
          end
        end
      end
    end
  end
end
