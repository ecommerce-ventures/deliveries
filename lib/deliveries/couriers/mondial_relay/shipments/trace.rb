module Deliveries
  module Couriers
    class MondialRelay < Deliveries::Courier
      module Shipments
        class Trace
          attr_accessor :tracking_code, :language

          def initialize(tracking_code:, language:)
            self.tracking_code = tracking_code
            self.language = language
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
                Deliveries.courier('mondial_relay')::StatusCodes.tracking_info_success?(response_result[:stat].to_i)

              response_result
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
