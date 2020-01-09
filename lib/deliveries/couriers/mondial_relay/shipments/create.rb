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
            response = MondialRelay.api_client.call :wsi2_creation_etiquette, message: params
            # If response returns OK stat code.
            response_result = response.body[:wsi2_creation_etiquette_response][:wsi2_creation_etiquette_result]
            if response_result && response_result[:stat] == '0'
              {
                tracking_code: response_result[:expedition_num],
                label_url: 'http://www.mondialrelay.com' + response_result[:url_etiquette].gsub('format=A4', 'format=10x15')
              }
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
