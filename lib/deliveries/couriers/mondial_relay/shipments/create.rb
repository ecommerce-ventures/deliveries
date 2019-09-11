module Deliveries
  module Couriers
    module MondialRelay
      module Shipments
        class Create
          attr_accessor :params

          def initialize(params:)
            self.params = params
          end

          def execute
            params['Security'] = Deliveries::Couriers::MondialRelay.calculate_security_param params

            # Call web service.
            response = MondialRelay.api_client.call :wsi2_creation_expedition, message: params
            # If response returns OK stat code.
            if (response_result = response.body[:wsi2_creation_expedition_response][:wsi2_creation_expedition_result]) &&
               response_result[:stat] == '0'

               response_result[:expedition_num]
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
