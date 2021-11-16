require 'deliveries/support/envialia_stubs'

include Deliveries::Couriers::Envialia::Authentication

RSpec.describe 'Envialia' do
  it '.login' do
    register_envialia_login_stubs

    response = session_id

    expect(response).not_to eql nil
    expect(response).to eq "{4ADFBA16-05FC-47AF-BB70-95D7DC61C161}"
  end

  it '.create_shipment' do
    register_envialia_create_shipment_stubs

    # Success
    # ---

    # Arrange
    sender = Deliveries::Address.new(
      name: 'Sender name',
      email: 'sender@example.com',
      phone: '666666666',
      country: 'ES',
      state: 'Bizkaia',
      city: 'Erandio',
      street: 'Sender street',
      postcode: '48950'
    )

    receiver = Deliveries::Address.new(
      name: 'Receiver name',
      email: 'receiver@example.com',
      phone: '666666666',
      country: 'ES',
      state: 'Bizkaia',
      city: 'Erandio',
      street: 'Receiver street',
      postcode: '48950'
    )

    # Act
    response = Deliveries.courier(:envialia).create_shipment(
      sender: sender,
      receiver: receiver,
      collection_point: nil,
      parcels: 1,
      reference_code: 'shipmentX',
      shipment_date: Date.tomorrow,
      remarks: nil
    )
  end

  it '.create_pickup' do
    # Arrange
    register_envialia_create_pickup_stubs

    # Success
    # ---

    # Arrange
    sender = Deliveries::Address.new(
      name: 'Sender name',
      email: 'sender@example.com',
      phone: '666666666',
      country: 'ES',
      state: 'Bizkaia',
      city: 'Erandio',
      street: 'Sender street',
      postcode: '48950'
    )
    receiver = Deliveries::Address.new(
      name: 'Receiver name',
      email: 'receiver@example.com',
      phone: '666666666',
      country: 'ES',
      state: 'Bizkaia',
      city: 'Erandio',
      street: 'Receiver street',
      postcode: '48950'
    )

    # Act
    response = Deliveries.courier(:envialia).create_pickup(
      sender: sender,
      receiver: receiver,
      parcels: 1,
      reference_code: 'shipmentX',
      pickup_date: Date.tomorrow,
      remarks: nil,
      tracking_code: '0128346910'
    )

    # Assert
    expect(response).to be_a Deliveries::Pickup
    expect(response.courier_id).to eq "envialia"
    expect(response.sender).to eq sender
    expect(response.receiver).to eq receiver
    expect(response.parcels).to eq 1
    expect(response.reference_code).to eq 'shipmentX'
    expect(response.tracking_code).to eq '0128346910'
    expect(response.pickup_date).to eq Date.tomorrow
  end

  it ".shipment_info" do
    # Arrange
    register_envialia_shipment_info_stubs

    # Success
    # ---

    # Act
    response = Deliveries.courier(:envialia).shipment_info(tracking_code: 'E001')

    # Assert
    expect(response).to be_a Deliveries::TrackingInfo
    expect(response.courier_id).to eq 'envialia'
    expect(response.tracking_code).to eq '1'
    expect(response.url).to eq nil
    expect(response.status).to eq :registered
    # expect(response.checkpoints).to be_a Array
    # checkpoint = response.checkpoints.first
    # expect(checkpoint).to be_a Deliveries::Checkpoint
    # expect(checkpoint.status).to eq :registered
    # expect(checkpoint.location).to eq nil
    # expect(checkpoint.tracked_at).to eq "#{Date.current} 11:12:13".in_time_zone('CET')
    # expect(checkpoint.description).to eq "SIN RECEPCION"

    # Error
    # ---

    # Act/Assert
    # expect {
    #   Deliveries.courier(:correos_express).shipment_info(tracking_code: 'E000')
    # }.to raise_error(Deliveries::APIError) do |error|
    #   expect(error.message).to eq 'ERROR EN BBDD - NO SE HAN ENCONTRADO DATOS'
    #   expect(error.code).to eq "402"
    # end
  end

end