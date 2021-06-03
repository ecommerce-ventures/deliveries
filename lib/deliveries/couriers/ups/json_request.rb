module Deliveries
  module Couriers
    module Ups
      module JsonRequest
        private

        def call(body, method: :post, url_params: {}, query_params: {})
          plain_response = HTTParty.public_send(
            method,
            api_endpoint % url_params,
            body: body&.to_json,
            query: query_params,
            headers: headers,
            debug_output: Deliveries.debug ? Deliveries.logger : nil,
            format: :plain
          )
          response = JSON.parse plain_response, symbolize_names: true

          if response.dig(:response, :errors).present?
            error_code = response.dig(:response, :errors, 0, :code)&.to_i
            error_message = response.dig(:response, :errors, 0, :message) || 'Unknown error'

            raise APIError.new(error_message, error_code)
          end

          response
        end

        def headers
          {
            'Content-Type': 'application/json',
            AccessLicenseNumber: Ups.config(:license_number),
            Username: Ups.config(:username),
            Password: Ups.config(:password)
          }
        end
      end
    end
  end
end
