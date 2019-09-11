require_relative 'spring/shipments/trace/format_response'
require_relative 'spring/shipments/trace'
require_relative 'spring/shipments/create/defaults'
require_relative 'spring/shipments/create/format_params'
require_relative 'spring/shipments/create'
require_relative 'spring/labels/generate'
require_relative 'spring/address'
require_relative 'spring/request'

module Deliveries
  module Couriers
    module Spring
      extend Courier

      ID = :spring
      ENDPOINT_LIVE = 'https://mtapi.net/'.freeze
      ENDPOINT_TEST = 'https://mtapi.net/?testMode=1'.freeze

      Config = Struct.new(
        :endpoint,
        :api_key,
        :countries,
        :default_product
      )

      module_function

      def shipment_info(tracking_code:, language: nil)
        response = Shipments::Trace.new(
          tracking_code: tracking_code
        ).execute

        tracking_info_params = Shipments::Trace::FormatResponse.new(response: response).execute
        Deliveries::TrackingInfo.new(tracking_info_params)
      end

      def get_label(tracking_code:, language: nil)
        get_labels(tracking_codes: tracking_code)
      end

      def get_labels(tracking_codes:, language: nil)
        pdf, url = Labels::Generate.new(
          tracking_codes: tracking_codes
        ).execute.values_at(:pdf, :url)

        Deliveries::Label.new(
          raw: pdf,
          url: url
        )
      end

      def create_shipment(sender:, receiver:, collection_point: nil, shipment_date: nil,
                          parcels:, reference_code:, remarks: nil)
        Shipments::Create.new(
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          reference_code: reference_code
        ).execute
      end
    end
  end
end
