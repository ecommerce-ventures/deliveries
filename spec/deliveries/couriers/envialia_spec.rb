require 'deliveries/support/envialia_stubs'

RSpec.describe 'Envialia' do
  it '.login' do
    register_envialia_login_stubs

    response = Deliveries.courier(:envialia).login

    expect(response).not_to eql nil
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
      remarks: nil
    )

    # Assert
    # expect(response).to be_a Deliveries::Pickup
    # expect(response.courier_id).to eq "envialia"
    # expect(response.sender).to eq sender
    # expect(response.receiver).to eq receiver
    # expect(response.parcels).to eq 1
    # expect(response.reference_code).to eq 'shipmentX'
    # expect(response.tracking_code).to eq '69153759'
    # expect(response.pickup_date).to eq Date.tomorrow
  end
end
