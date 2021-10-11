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

      COURIER_ID = :spring
      ENDPOINT_LIVE = 'https://mtapi.net/'.freeze
      ENDPOINT_TEST = 'https://mtapi.net/?testMode=1'.freeze

      Config = Struct.new(
        :api_key,
        :countries,
        :default_product
      )

      module_function

      def shipment_info(tracking_code:, **)
        response = Shipments::Trace.new(
          tracking_code: tracking_code
        ).execute

        tracking_info_params = Shipments::Trace::FormatResponse.new(response: response).execute
        Deliveries::TrackingInfo.new(**tracking_info_params)
      end

      def get_label(tracking_code:, **)
        decoded_label, url = Labels::Generate.new(
          tracking_code: tracking_code
        ).execute.values_at(:decoded_label, :url)

        Deliveries::Label.new(
          raw: decoded_label,
          url: url
        )
      end

      def get_labels(tracking_codes:, **)
        labels = Deliveries::Labels.new

        tracking_codes.each do |tracking_code|
          labels << get_label(tracking_code: tracking_code)
        end

        labels
      end

      def create_shipment(sender:, receiver:, parcels:, reference_code:, shipment_date: nil, **)
        delivery = Shipments::Create.new(
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          reference_code: reference_code
        ).execute

        Deliveries::Shipment.new(delivery: delivery, shipment_date: shipment_date)
      end

      def create_pickup(sender:, receiver:, parcels:, reference_code:, pickup_date: nil, **)
        delivery = Shipments::Create.new(
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          reference_code: reference_code
        ).execute

        Deliveries::Pickup.new(delivery: delivery, pickup_date: pickup_date)
      end

      def pickup_info(tracking_code:, **)
        shipment_info(tracking_code: tracking_code)
      end
    end
  end
end
