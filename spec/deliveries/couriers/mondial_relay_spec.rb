require 'rails_helper'
require 'deliveries/support/mondial_relay_stubs'

describe "Mondial Relay" do

  before do
    savon.mock!
    register_mondial_relay_wsdl
  end

  after do
    savon.unmock!
  end

  it ".get_collection_point" do
    # Arrange
    register_mondial_relay_get_collection_point_stubs

    # Success
    # ---

    # Act
    response = Deliveries.courier(:mondial_relay).get_collection_point(global_point_id: 'mondial_relay~fr~00001~XXXXX1')
    # Assert
    collection_point = response
    expect(collection_point).to be_a Deliveries::CollectionPoint
    expect(collection_point.courier_id).to eq 'mondial_relay'
    expect(collection_point.name).to eq 'Collection point addr 1'
    expect(collection_point.point_id).to eq 'XXXXX1'
    expect(collection_point.street).to eq 'Collection point addr 3'
    expect(collection_point.city).to eq 'Collection point ville'
    expect(collection_point.postcode).to eq '00001'
    expect(collection_point.latitude).to eq -45.750594
    expect(collection_point.longitude).to eq 166.578292
    expect(collection_point.timetable).to be_a Hash
    expect(collection_point.timetable.length).to eq 7
    expect(collection_point.timetable[0]).to eq nil
    expect(collection_point.timetable[1]).to eq [OpenStruct.new(open: '09:30', close: '15:30')]
    expect(collection_point.timetable[2]).to eq [OpenStruct.new(open: '09:30', close: '19:30')]
    expect(collection_point.timetable[3]).to eq [OpenStruct.new(open: '09:30', close: '19:30')]
    expect(collection_point.timetable[4]).to eq [OpenStruct.new(open: '09:30', close: '19:30')]
    expect(collection_point.timetable[5]).to eq [OpenStruct.new(open: '09:30', close: '19:30')]
    expect(collection_point.timetable[6]).to eq [OpenStruct.new(open: '09:30', close: '18:30')]
    expect(collection_point.email).to eq nil
    expect(collection_point.phone).to eq nil
    expect(collection_point.country).to eq 'FR'
    expect(collection_point.state).to eq nil

    # Error
    # ---

    # Act/Assert
    expect {
      Deliveries.courier(:mondial_relay).get_collection_point(global_point_id: 'mondial_relay~fr~00000~XXXXXX')
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'Incorrect Point Relais number'
      expect(error.code).to eq '70'
    end
  end

  it ".get_collection_points" do
    # Arrange
    register_mondial_relay_get_collection_points_stubs

    # Success
    # ---

    # Act
    response = Deliveries.courier(:mondial_relay).get_collection_points(postcode: '00001', country: 'fr')
    # Assert
    expect(response).to be_a Array
    collection_point = response.first
    expect(collection_point).to be_a Deliveries::CollectionPoint
    expect(collection_point.courier_id).to eq 'mondial_relay'
    expect(collection_point.name).to eq 'Collection point addr 1'
    expect(collection_point.point_id).to eq 'XXXXX1'
    expect(collection_point.street).to eq 'Collection point addr 3'
    expect(collection_point.city).to eq 'Collection point ville'
    expect(collection_point.postcode).to eq '00001'
    expect(collection_point.latitude).to eq -45.750594
    expect(collection_point.longitude).to eq 166.578292
    expect(collection_point.timetable).to be_a Hash
    expect(collection_point.timetable.length).to eq 7
    expect(collection_point.timetable[0]).to eq nil
    expect(collection_point.timetable[1]).to eq [OpenStruct.new(open: '09:30', close: '15:30')]
    expect(collection_point.timetable[2]).to eq [OpenStruct.new(open: '09:30', close: '19:30')]
    expect(collection_point.timetable[3]).to eq [OpenStruct.new(open: '09:30', close: '19:30')]
    expect(collection_point.timetable[4]).to eq [OpenStruct.new(open: '09:30', close: '19:30')]
    expect(collection_point.timetable[5]).to eq [OpenStruct.new(open: '09:30', close: '19:30')]
    expect(collection_point.timetable[6]).to eq [OpenStruct.new(open: '09:30', close: '18:30')]
    expect(collection_point.email).to eq nil
    expect(collection_point.phone).to eq nil
    expect(collection_point.country).to eq 'FR'
    expect(collection_point.state).to eq nil

    # Act/Assert
    response = Deliveries.courier(:mondial_relay).get_collection_points(postcode: '00000', country: 'fr')
    expect(response).to eq []

    # Error
    # ---

    # Act/Assert
    expect {
      Deliveries.courier(:mondial_relay).get_collection_points(postcode: '', country: 'fr')
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'Missing parameters'
      expect(error.code).to eq '40'
    end
  end

  it ".create_shipment" do
    # Arrange
    register_mondial_relay_create_shipment_stubs

    # Success
    # ---

    # Arrange
    sender = Deliveries::Address.new(
      name: 'Sender name',
      email: 'sender@example.com',
      phone: '+34999999999',
      country: 'ES',
      state: 'Bizkaia',
      city: 'Erandio',
      street: 'Sender street',
      postcode: '48950'
    )
    receiver = Deliveries::Address.new(
      name: 'Receiver name',
      email: 'receiver@example.com',
      phone: '+34999999999',
      country: 'ES',
      state: 'Bizkaia',
      city: 'Erandio',
      street: 'Receiver street',
      postcode: '48950'
    )

    # Act
    response = Deliveries.courier(:mondial_relay).create_shipment(
      sender: sender,
      receiver: receiver,
      collection_point: nil,
      parcels: 1,
      reference_code: 'shipmentX',
      remarks: nil
    )

    # Assert
    expect(response).to be_a Deliveries::Delivery
    expect(response.courier_id).to eq "mondial_relay"
    expect(response.sender).to eq sender
    expect(response.receiver).to eq receiver
    expect(response.parcels).to eq 1
    expect(response.reference_code).to eq 'shipmentX'
    expect(response.tracking_code).to eq '31297410'

    # Error
    # ---

    # Arrange
    receiver.name = ''

    # Act/Assert
    expect {
      Deliveries.courier(:mondial_relay).create_shipment(
        sender: sender,
        receiver: receiver,
        collection_point: nil,
        parcels: 1,
        reference_code: 'shipmentX',
        shipment_date: Date.tomorrow,
        remarks: nil
      )
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'Incorrect address (L1)'
      expect(error.code).to eq '30'
    end
  end

  it ".create_pickup" do
    # Arrange
    register_mondial_relay_create_pickup_stubs

    # Success
    # ---

    # Arrange
    sender = Deliveries::Address.new(
      name: 'Sender name',
      email: 'sender@example.com',
      phone: '+34999999999',
      country: 'ES',
      state: 'Bizkaia',
      city: 'Erandio',
      street: 'Sender street',
      postcode: '48950'
    )
    receiver = Deliveries::Address.new(
      name: 'Receiver name',
      email: 'receiver@example.com',
      phone: '+34999999999',
      country: 'ES',
      state: 'Bizkaia',
      city: 'Erandio',
      street: 'Receiver street',
      postcode: '48950'
    )

    # Act
    response = Deliveries.courier(:mondial_relay).create_pickup(
      sender: sender,
      receiver: receiver,
      parcels: 1,
      reference_code: 'shipmentX',
      pickup_date: Date.tomorrow,
      remarks: nil
    )

    # Assert
    expect(response).to be_a Deliveries::Pickup
    expect(response.courier_id).to eq "mondial_relay"
    expect(response.sender).to eq sender
    expect(response.receiver).to eq receiver
    expect(response.parcels).to eq 1
    expect(response.reference_code).to eq 'shipmentX'
    expect(response.tracking_code).to eq '31297410'
    expect(response.pickup_date).to eq Date.tomorrow

    # Error
    # ---

    # Arrange
    receiver.name = ''

    # Act/Assert
    expect {
      Deliveries.courier(:mondial_relay).create_pickup(
        sender: sender,
        receiver: receiver,
        parcels: 1,
        reference_code: 'shipmentX',
        pickup_date: Date.tomorrow,
        remarks: nil
      )
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'Incorrect address (L1)'
      expect(error.code).to eq '30'
    end
  end

  it ".get_label" do
    # Arrange
    register_mondial_relay_get_label_stubs

    # Success
    # ---

    # Act
    response = Deliveries.courier(:mondial_relay).get_label(tracking_code: 'E001')
    # Assert
    expect(response.url).to eq 'http://www.mondialrelay.com/ww2/PDF/StickerMaker2.aspx?ens=ESMICOLE38&expedition=E001&lg=FR&format=10x15&crc=04F2969A9D2159C9F72721F221E8F777'
    expect(pdf_pages_count(response.raw).to_i).to eq 1

    # Error
    # ---

    # Act/Assert
    expect {
      Deliveries.courier(:mondial_relay).get_label(tracking_code: 'E000')
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'Incorrect shipment number'
      expect(error.code).to eq '24'
    end
  end

  it ".get_labels" do
    # Arrange
    register_mondial_relay_get_labels_stubs

    # Success
    # ---

    # Act
    response = Deliveries.courier(:mondial_relay).get_labels(tracking_codes: %w[E001 E002])
    # Assert
    expect(response.url).to eq "http://www.mondialrelay.com/ww2/PDF/StickerMaker2.aspx?ens=ESMICOLE38&expedition=E001;E002&lg=FR&format=10x15&crc=04F2969A9D2159C9F72721F221E8F777"
    expect(pdf_pages_count(response.raw).to_i).to eq 2

    # Error
    # ---

    # Act/Assert
    expect {
      Deliveries.courier(:mondial_relay).get_labels(tracking_codes: %w[E001 E000])
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'Incorrect shipment number'
      expect(error.code).to eq '24'
    end
  end

  it ".shipment_info" do
    # Arrange
    register_mondial_relay_shipment_info_stubs

    # Success
    # ---

    # Act
    response = Deliveries.courier(:mondial_relay).shipment_info(tracking_code: 'E001')
    # Assert
    expect(response).to be_a Deliveries::TrackingInfo
    expect(response.courier_id).to eq 'mondial_relay'
    expect(response.tracking_code).to eq 'E001'
    expect(response.url).to eq nil
    expect(response.status).to eq :in_transit
    expect(response.checkpoints).to be_a Array
    checkpoint = response.checkpoints.first
    expect(checkpoint).to be_a Deliveries::Checkpoint
    expect(checkpoint.status).to eq :registered
    expect(checkpoint.location).to eq nil
    expect(checkpoint.tracked_at).to eq "#{Date.yesterday} 10:10:00".in_time_zone
    expect(checkpoint.description).to eq "RÉCEPTION DES DONNÉES"
    checkpoint = response.checkpoints.last
    expect(checkpoint).to be_a Deliveries::Checkpoint
    expect(checkpoint.status).to eq :in_transit
    expect(checkpoint.location).to eq 'ESPAGNE'
    expect(checkpoint.tracked_at).to eq "#{Date.current} 11:11:00".in_time_zone
    expect(checkpoint.description).to eq "PRISE EN CHARGE EN AGENCE"

    # Error
    # ---

    # Act/Assert
    expect {
      Deliveries.courier(:mondial_relay).shipment_info(tracking_code: 'E000')
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'Incorrect shipment number'
      expect(error.code).to eq "24"
    end
  end

  it ".pickup_info" do
    # Arrange
    register_mondial_relay_shipment_info_stubs

    # Success
    # ---

    # Act
    response = Deliveries.courier(:mondial_relay).shipment_info(tracking_code: 'E001')
    # Assert
    expect(response).to be_a Deliveries::TrackingInfo
    expect(response.courier_id).to eq 'mondial_relay'
    expect(response.tracking_code).to eq 'E001'
    expect(response.url).to eq nil
    expect(response.status).to eq :in_transit
    expect(response.checkpoints).to be_a Array
    checkpoint = response.checkpoints.first
    expect(checkpoint).to be_a Deliveries::Checkpoint
    expect(checkpoint.status).to eq :registered
    expect(checkpoint.location).to eq nil
    expect(checkpoint.tracked_at).to eq "#{Date.yesterday} 10:10:00".in_time_zone
    expect(checkpoint.description).to eq "RÉCEPTION DES DONNÉES"
    checkpoint = response.checkpoints.last
    expect(checkpoint).to be_a Deliveries::Checkpoint
    expect(checkpoint.status).to eq :in_transit
    expect(checkpoint.location).to eq 'ESPAGNE'
    expect(checkpoint.tracked_at).to eq "#{Date.current} 11:11:00".in_time_zone
    expect(checkpoint.description).to eq "PRISE EN CHARGE EN AGENCE"

    # Error
    # ---

    # Act/Assert
    expect {
      Deliveries.courier(:mondial_relay).shipment_info(tracking_code: 'E000')
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'Incorrect shipment number'
      expect(error.code).to eq "24"
    end
  end
end