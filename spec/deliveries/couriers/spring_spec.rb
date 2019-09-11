require 'rails_helper'
require 'deliveries/support/spring_stubs'

describe "Spring" do

  it ".get_collection_point" do
    # Act/Assert
    expect {
      Deliveries.courier(:spring).get_collection_point(global_point_id: nil)
    }.to raise_error NotImplementedError
  end

  it ".get_collection_points" do
    # Act/Assert
    expect {
      Deliveries.courier(:spring).get_collection_points(postcode: nil, country: nil)
    }.to raise_error NotImplementedError
  end

  it ".create_shipment" do
    # Arrange
    register_spring_create_shipment_stub

    # Success
    # ---

    # Arrange
    sender = Deliveries::Address.new(
      name: 'Sender name',
      email: 'sender@example.com',
      phone: '666666666',
      country: 'ES',
      state: 'Sender state',
      city: 'Sender city',
      street: 'Sender street',
      postcode: '00000'
    )
    receiver = Deliveries::Address.new(
      name: 'Receiver name',
      email: 'receiver@example.com',
      phone: '666666666',
      country: 'GB',
      state: 'Receiver state',
      city: 'Receiver city',
      street: 'Receiver street',
      postcode: '00000'
    )

    # Act
    response = Deliveries.courier(:spring).create_shipment(
      sender: sender,
      receiver: receiver,
      parcels: 1,
      reference_code: 'shipmentX'
    )

    # Assert
    expect(response).to be_a Deliveries::Delivery
    expect(response.courier_id).to eq :spring
    expect(response.sender).to eq sender
    expect(response.receiver).to eq receiver
    expect(response.parcels).to eq 1
    expect(response.reference_code).to eq 'shipmentX'
    expect(response.tracking_code).to eq 'shipmentX001'

    # Error
    # ---

    # Arrange
    receiver.name = ''

    # Act/Assert
    expect {
      Deliveries.courier(:spring).create_shipment(
        sender: sender,
        receiver: receiver,
        parcels: 1,
        reference_code: 'shipmentX'
      )
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'Consignee Name required'
      expect(error.code).to eq 1
    end
  end

  it ".create_pickup" do
    # Act/Assert
    expect {
      Deliveries.courier(:spring).create_pickup(
        sender: nil,
        receiver: nil,
        parcels: nil,
        reference_code: nil
      )
    }.to raise_error NotImplementedError
  end

  it ".get_label" do
    # Arrange
    register_spring_get_label_stub

    # Success
    # ---

    # Act
    response = Deliveries.courier(:spring).get_label(tracking_code: '001')
    # Assert
    expect(response.url).to eq "http://tracking.url.example/001"
    expect(pdf_pages_count(response.raw).to_i).to eq 1

    # Error
    # ---

    # Act/Assert
    expect {
      Deliveries.courier(:spring).get_label(tracking_code: '000')
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'Shipment not found (000)'
      expect(error.code).to eq 10
    end
  end

  it ".get_labels" do
    # Arrange
    register_spring_get_label_stub

    # Success
    # ---

    # Act
    response = Deliveries.courier(:spring).get_labels(tracking_codes: %w[001 002])

    # Assert
    expect(response.url).to be_nil
    expect(pdf_pages_count(response.raw).to_i).to eq 2

    # Error
    # ---

    # Act/Assert
    expect {
      Deliveries.courier(:spring).get_labels(tracking_codes: %w[001 000])
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'Shipment not found (000)'
      expect(error.code).to eq 10
    end
  end

  it ".shipment_info" do
    # Arrange
    register_spring_shipment_info_stub

    # Success
    # ---

    # Act
    response = Deliveries.courier(:spring).shipment_info(tracking_code: '001')

    # Assert
    expect(response).to be_a Deliveries::TrackingInfo
    expect(response.courier_id).to eq :spring
    expect(response.tracking_code).to eq '001'
    expect(response.status).to eq :registered
    expect(response.checkpoints.length).to eq 1
    checkpoint = response.checkpoints.first
    expect(checkpoint).to be_a Deliveries::Checkpoint
    expect(checkpoint.status).to eq :registered
    expect(checkpoint.location).to eq nil
    expect(checkpoint.tracked_at).to eq '2000-01-01 10:10:10'.in_time_zone
    expect(checkpoint.description).to eq nil

    # Error
    # ---

    # Act/Assert
    expect {
      Deliveries.courier(:spring).shipment_info(tracking_code: '000')
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'Shipment not found (000)'
      expect(error.code).to eq 10
    end
  end

  it ".pickup_info" do
    # Act/Assert
    expect {
      Deliveries.courier(:spring).pickup_info(tracking_code: nil, language: nil)
    }.to raise_error NotImplementedError
  end
end
