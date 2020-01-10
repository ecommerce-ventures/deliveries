module Deliveries
  module Couriers
    module MondialRelay
      module Shipments
        class Trace
          SUPPORTED_LANGUAGES = %i[fr es nl en].freeze

          attr_accessor :tracking_code, :language

          def initialize(tracking_code:, language:)
            self.tracking_code = tracking_code
            self.language =
              if SUPPORTED_LANGUAGES.include? language&.to_sym&.downcase
                language
              else
                'en'
              end
          end

          def execute
            params = { 'Enseigne' => Deliveries::Couriers::MondialRelay.config(:mondial_relay_merchant),
                       'Expedition' => tracking_code,
                       'Langue' => language }

            params['Security'] = Deliveries::Couriers::MondialRelay.calculate_security_param params

            # Call web service.
            response = MondialRelay.api_client.call :wsi2_tracing_colis_detaille, message: params

            response_result = response.body.dig(:wsi2_tracing_colis_detaille_response, :wsi2_tracing_colis_detaille_result)
            if  response_result.present? &&
                StatusCodes.tracking_info_success?(response_result[:stat].to_i)

              response_result
            else
              raise Deliveries::APIError.new(
                StatusCodes.message_for(response_result[:stat].to_i),
                response_result[:stat]
              )
            end
          end
        end
      end
    end
  end
end
