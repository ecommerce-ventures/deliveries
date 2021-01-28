module Deliveries
  module Couriers
    module Ups
      module Shipments
        class Trace
          include JsonRequest

          attr_accessor :tracking_code, :language

          def initialize(tracking_code:, language: nil)
            self.tracking_code = tracking_code
            self.language = language
          end

          def execute
            response = call nil, method: :get, url_params: { inquiry_number: tracking_code }, query_params: { locale: locale }

            package = response.dig(:trackResponse, :shipment, 0, :package, 0, :activity)
            raise Error, 'Cannot obtain package activity data' if package.nil? || package.empty?

            package.map do |activity|
              {
                status: status(activity.dig(:status, :type), activity.dig(:status, :code)),
                location: activity.dig(:location, :address, :city),
                tracked_at: DateTime.parse("#{activity[:date]}T#{activity[:time]}"),
                description: activity.dig(:status, :description)
              }
            end.sort_by{ |activity| activity[:tracked_at] }
          end

          private

          def api_endpoint
            if Ups.live?
              "https://onlinetools.ups.com/track/v1/details/%<inquiry_number>s"
            else
              "https://wwwcie.ups.com/track/v1/details/%<inquiry_number>s"
            end
          end

          def locale
            case language&.to_sym&.downcase
            when :es then 'es_ES'
            when :fr then 'fr_FR'
            when :pt then 'pt_PT'
            when :it then 'it_IT'
            when :de then 'de_DE'
            when :en then 'en_GB'
            when :pl then 'pl_PL'
            else 'en_US'
            end
          end

          def status(type, code)
            case type&.to_s&.upcase
            when 'M'
              :registered
            when 'I', 'P', 'O'
              :in_transit
            when 'D'
              if %w{2Q ZP}.include?(code&.to_s&.upcase)
                :in_collection_point
              else
                :delivered
              end
            when 'MV'
              :canceled
            else
              :unknown_status
            end
          end
        end
      end
    end
  end
end
