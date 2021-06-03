module Deliveries
  module Couriers
    module MondialRelay
      module Labels
        class Generate
          attr_accessor :tracking_codes, :language

          def initialize(tracking_codes:, language:)
            self.tracking_codes = [tracking_codes].flatten.join(';')
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

            response = MondialRelay.api_client.call :wsi3_get_etiquettes, message: params
            response_stat = response.body.dig(:wsi3_get_etiquettes_response, :wsi3_get_etiquettes_result, :stat)
            if response_stat == '0'
              # Get path for 10x15 format.
              "http://www.mondialrelay.com#{response.body.dig(:wsi3_get_etiquettes_response,
                                                              :wsi3_get_etiquettes_result, :url_pdf_10x15)}"
            else
              raise Deliveries::APIError.new(
                StatusCodes.message_for(response_stat.to_i),
                response_stat
              )
            end
          end
        end
      end
    end
  end
end
