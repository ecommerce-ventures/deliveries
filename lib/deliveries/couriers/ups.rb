require_relative 'ups/json_request'
require_relative 'ups/collection_points/search'
require_relative 'ups/shipments/create'
require_relative 'ups/shipments/trace'
require_relative 'ups/labels/generate'

module Deliveries
  module Couriers
    module Ups
      extend Courier

      COURIER_ID = :ups

      Config = Struct.new(
        :license_number,
        :username,
        :password,
        :account_number,
        :default_product
      )

      module_function

      def get_collection_point(global_point_id:)
        global_point = CollectionPoint.parse_global_point_id(global_point_id: global_point_id)
        points = CollectionPoints::Search.new(
          country: global_point.country,
          point_id: global_point.point_id
        ).execute

        raise Error, 'No collection point found by that point ID' if points.empty?

        CollectionPoint.new(**points.first)
      end

      def get_collection_points(country:, postcode:)
        points = CollectionPoints::Search.new(
          country: country,
          postcode: postcode
        ).execute

        points.map do |arguments|
          CollectionPoint.new(**arguments)
        end
      end

      def create_shipment(sender:, receiver:, parcels:, reference_code:, collection_point:, shipment_date: nil, language: nil, **)
        tracking_code, label = Shipments::Create.new(
          shipper: sender,
          consignee: receiver,
          parcels: parcels,
          reference_code: reference_code,
          type: :forward,
          collection_point: collection_point,
          language: language
        ).execute.values_at(:tracking_code, :label)

        Deliveries::Shipment.new(
          courier_id: COURIER_ID,
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          reference_code: reference_code,
          tracking_code: tracking_code,
          shipment_date: shipment_date,
          label: Label.new(raw: label)
        )
      end

      def create_pickup(sender:, receiver:, parcels:, reference_code:, pickup_date: nil, language: nil, **)
        tracking_code, label = Shipments::Create.new(
          shipper: receiver,
          consignee: sender,
          parcels: parcels,
          reference_code: reference_code,
          type: :return,
          language: language
        ).execute.values_at(:tracking_code, :label)

        Deliveries::Pickup.new(
          courier_id: COURIER_ID,
          sender: sender,
          receiver: receiver,
          parcels: parcels,
          reference_code: reference_code,
          tracking_code: tracking_code,
          pickup_date: pickup_date,
          label: Label.new(raw: label)
        )
      end

      def get_label(tracking_code:, language: nil)
        arguments = Labels::Generate.new(tracking_code: tracking_code).execute
        Label.new(**arguments)
      end

      def get_labels(tracking_codes:, language: nil)
        labels = Deliveries::Labels.new

        tracking_codes.each do |tracking_code|
          labels << get_label(tracking_code: tracking_code)
        end

        labels
      end

      def shipment_info(tracking_code:, language: nil)
        checkpoints = Shipments::Trace.new(tracking_code: tracking_code, language: language).execute.map do |arguments|
          Checkpoint.new(**arguments)
        end

        TrackingInfo.new(courier_id: COURIER_ID, tracking_code: tracking_code, checkpoints: checkpoints, status: checkpoints.last&.status)
      end

      def pickup_info(tracking_code:, language: nil)
        shipment_info(tracking_code: tracking_code, language: language)
      end
    end
  end
end
