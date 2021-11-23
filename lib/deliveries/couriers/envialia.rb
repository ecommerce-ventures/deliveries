require_relative 'envialia/authentication'
require_relative 'envialia/shipments/create'
require_relative 'envialia/shipments/trace/format_response'
require_relative 'envialia/shipments/trace'
require_relative 'envialia/pickups/trace/format_response'
require_relative 'envialia/pickups/trace'
require_relative 'envialia/pickups/create'
require_relative 'envialia/labels/generate'

module Deliveries
  module Couriers
    module Envialia
      extend Courier

      Config = Struct.new(
        :username,
        :password,
        :agency_code
      )

      module_function

      def create_shipment(sender:, receiver:, parcels:, reference_code:, collection_point: nil, shipment_date: nil, remarks: nil, **)
        Shipments::Create.new(
          sender: sender,
          receiver: receiver,
          collection_point: collection_point,
          shipment_date: shipment_date,
          parcels: parcels,
          reference_code: reference_code,
          remarks: remarks
        ).execute
      end

      def create_pickup(sender:, receiver:, parcels:, reference_code:, pickup_date: nil, remarks: nil, tracking_code: nil, **)
        Pickups::Create.new(
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          reference_code: reference_code,
          pickup_date: pickup_date,
          remarks: remarks,
          tracking_code: tracking_code
        ).execute
      end

      def shipment_info(tracking_code:, **)
        response = Shipments::Trace.new(
          tracking_code: tracking_code
        ).execute

        tracking_info_params = Shipments::Trace::FormatResponse.new(response: response).execute
        tracking_info_params.merge!({ tracking_code: tracking_code })
        Deliveries::TrackingInfo.new(**tracking_info_params)
      end

      def pickup_info(tracking_code:, **)
        response = Pickups::Trace.new(
          tracking_code: tracking_code
        ).execute

        tracking_info_params = Pickups::Trace::FormatResponse.new(response: response).execute
        tracking_info_params.merge!({ tracking_code: tracking_code })
        Deliveries::TrackingInfo.new(**tracking_info_params)
      end

      def get_label(tracking_code:, **)
        pdf = Labels::Generate.new(
          tracking_codes: tracking_code
        ).execute.first

        Deliveries::Label.new(raw: pdf)
      end

      def get_labels(tracking_codes:, **)
        labels = Deliveries::Labels.new

        Labels::Generate.new(
          tracking_codes: tracking_codes
        ).execute.each do |pdf|
          labels << pdf
        end

        labels
      end

    end
  end
end
