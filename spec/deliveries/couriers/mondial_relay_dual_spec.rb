require 'rails_helper'
require 'deliveries/support/mondial_relay_dual_stubs'

describe "Mondial Relay Dual" do
  it ".create_shipment" do
    # Arrange
    register_mondial_relay_dual_create_shipment_stubs

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
    response = Deliveries.courier(:mondial_relay_dual).create_shipment(
      sender: sender,
      receiver: receiver,
      collection_point: nil,
      parcels: 1,
      reference_code: 'shipmentX',
      remarks: nil,
      shipment_date: Date.tomorrow,
      language: 'es'
    )

    # Assert
    expect(response).to be_a Deliveries::Shipment
    expect(response.courier_id).to eq "mondial_relay_dual"
    expect(response.sender).to eq sender
    expect(response.receiver).to eq receiver
    expect(response.parcels).to eq 1
    expect(response.reference_code).to eq 'shipmentX'
    expect(response.tracking_code).to eq '96671332'
    expect(response.shipment_date).to eq Date.tomorrow
    expect(response.label.url).to eq 'https://connect-sandbox.mondialrelay.com//BDTEST/etiquette/GetStickersExpeditionsAnonyme2?ens=BDTEST&expedition=96671332&lg=es-ES&format=10x15&crc=2D4FBA4AEEF3FD29F492397CFF65C48E'

    # Error
    # ---

    # Arrange
    receiver.phone = ''

    # Act/Assert
    expect {
      Deliveries.courier(:mondial_relay_dual).create_shipment(
        sender: sender,
        receiver: receiver,
        collection_point: nil,
        parcels: 1,
        reference_code: 'shipmentX',
        shipment_date: Date.tomorrow,
        remarks: nil,
        language: 'es'
      )
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'Service_Expedition_DomicileTelephoneRequis'
      expect(error.code).to eq '10051'
    end
  end

  it ".create_pickup" do
    # Arrange
    register_mondial_relay_dual_create_pickup_stubs

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
    response = Deliveries.courier(:mondial_relay_dual).create_pickup(
      sender: sender,
      receiver: receiver,
      parcels: 1,
      reference_code: 'shipmentX',
      pickup_date: Date.tomorrow,
      remarks: nil,
      language: 'es'
    )

    # Assert
    expect(response).to be_a Deliveries::Pickup
    expect(response.courier_id).to eq "mondial_relay_dual"
    expect(response.sender).to eq sender
    expect(response.receiver).to eq receiver
    expect(response.parcels).to eq 1
    expect(response.reference_code).to eq 'shipmentX'
    expect(response.tracking_code).to eq '96671335'
    expect(response.pickup_date).to eq Date.tomorrow
    expect(response.label.url).to eq 'https://connect-sandbox.mondialrelay.com//BDTEST/etiquette/GetStickersExpeditionsAnonyme2?ens=BDTEST&expedition=96671335&lg=fr-FR&format=10x15&crc=59A88FDCEA84F5141B0AC00B28E1515C'

    # Error
    # ---

    # Arrange
    receiver.city = ''

    # Act/Assert
    expect {
      Deliveries.courier(:mondial_relay_dual).create_pickup(
        sender: sender,
        receiver: receiver,
        parcels: 1,
        reference_code: 'shipmentX',
        pickup_date: Date.tomorrow,
        remarks: nil,
        language: 'es'
      )
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'Ciudad vacia para la dirección Destinatario.'
      expect(error.code).to eq '10047'
    end
  end
end
