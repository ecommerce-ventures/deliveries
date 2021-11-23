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

    # Error
    # ---

    # Arrange
    sender.postcode = ''

    expect {
      Deliveries.courier(:envialia).create_shipment(
        sender: sender,
        receiver: receiver,
        collection_point: nil,
        parcels: 1,
        reference_code: 'shipmentX',
        shipment_date: Date.tomorrow,
        remarks: nil
      )
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'El código postal origen es nulo o no válido'
      expect(error.code).to eq 41
    end
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

    # Error
    # ---

    # Arrange
    sender.postcode = ''

    expect {
      Deliveries.courier(:envialia).create_pickup(
        sender: sender,
        receiver: receiver,
        parcels: 1,
        reference_code: 'shipmentX',
        pickup_date: Date.tomorrow,
        remarks: nil,
        tracking_code: '0128346910'
      )
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'La agencia de origen no existe o está inactiva'
      expect(error.code).to eq 7
    end
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
    expect(response.tracking_code).to eq 'E001'
    expect(response.url).to eq nil
    expect(response.status).to eq :delivered
    expect(response.checkpoints.length).to eq 4
    expect(response.checkpoints[0]).to be_a Deliveries::Checkpoint
    expect(response.checkpoints[0].status).to eq :registered
    expect(response.checkpoints[0].location).to eq nil
    expect(response.checkpoints[0].tracked_at).to eq "#{Date.yesterday} 11:11:11".in_time_zone
    expect(response.checkpoints[0].description).to eq 'Documentado'
    expect(response.checkpoints[1]).to be_a Deliveries::Checkpoint
    expect(response.checkpoints[1].status).to eq :in_transit
    expect(response.checkpoints[1].location).to eq nil
    expect(response.checkpoints[1].tracked_at).to eq "#{Date.yesterday} 12:12:12".in_time_zone
    expect(response.checkpoints[1].description).to eq 'En Tránsito'
    expect(response.checkpoints[2]).to be_a Deliveries::Checkpoint
    expect(response.checkpoints[2].status).to eq :cancelled
    expect(response.checkpoints[2].location).to eq nil
    expect(response.checkpoints[2].tracked_at).to eq "#{Date.yesterday} 13:13:13".in_time_zone
    expect(response.checkpoints[2].description).to eq 'Devuelto'
    expect(response.checkpoints[3]).to be_a Deliveries::Checkpoint
    expect(response.checkpoints[3].status).to eq :delivered
    expect(response.checkpoints[3].location).to eq nil
    expect(response.checkpoints[3].tracked_at).to eq "#{Date.yesterday} 14:14:14".in_time_zone
    expect(response.checkpoints[3].description).to eq 'Entregado'

    # Error
    # ---

    # Act/Assert
    expect {
      Deliveries.courier(:envialia).shipment_info(tracking_code: 'E000')
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'No se han encontrado datos para este envío'
      expect(error.code).to eq "402"
    end
  end

  it ".pickup_info" do
    # Arrange
    register_envialia_pickup_info_stubs

    # Success
    # ---

    # Act
    response = Deliveries.courier(:envialia).pickup_info(tracking_code: 'E001')

    # Assert
    expect(response).to be_a Deliveries::TrackingInfo
    expect(response.courier_id).to eq 'envialia'
    expect(response.tracking_code).to eq 'E001'
    expect(response.url).to eq nil
    expect(response.status).to eq :delivered
    expect(response.checkpoints).to be_a Array
    expect(response.checkpoints.length).to eq 4
    expect(response.checkpoints[0]).to be_a Deliveries::Checkpoint
    expect(response.checkpoints[0].status).to eq :registered
    expect(response.checkpoints[0].location).to eq nil
    expect(response.checkpoints[0].tracked_at).to eq "#{Date.yesterday} 11:11:11".in_time_zone
    expect(response.checkpoints[0].description).to eq 'Solicitada'
    expect(response.checkpoints[1]).to be_a Deliveries::Checkpoint
    expect(response.checkpoints[1].status).to eq :in_transit
    expect(response.checkpoints[1].location).to eq nil
    expect(response.checkpoints[1].tracked_at).to eq "#{Date.yesterday} 12:12:12".in_time_zone
    expect(response.checkpoints[1].description).to eq 'Realizada'
    expect(response.checkpoints[2]).to be_a Deliveries::Checkpoint
    expect(response.checkpoints[2].status).to eq :cancelled
    expect(response.checkpoints[2].location).to eq nil
    expect(response.checkpoints[2].tracked_at).to eq "#{Date.yesterday} 13:13:13".in_time_zone
    expect(response.checkpoints[2].description).to eq 'Anulada'
    expect(response.checkpoints[3]).to be_a Deliveries::Checkpoint
    expect(response.checkpoints[3].status).to eq :delivered
    expect(response.checkpoints[3].location).to eq nil
    expect(response.checkpoints[3].tracked_at).to eq "#{Date.yesterday} 14:14:14".in_time_zone
    expect(response.checkpoints[3].description).to eq 'Finalizada'

    # Error
    # ---

    # Act/Assert
    expect {
      Deliveries.courier(:envialia).pickup_info(tracking_code: 'E000')
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'No se han encontrado datos para este envío'
      expect(error.code).to eq "402"
    end
  end

  it ".get_label" do
    # Arrange
    register_envialia_get_label_stubs

    # Success
    # ---

    # Act
    response = Deliveries.courier(:envialia).get_label(tracking_code: 'E001')

    # Assert
    expect(response.url).to eq nil
    expect(pdf_pages_count(response.raw).to_i).to eq 1

    # Error
    # ---

    # Act/Assert
    expect {
      Deliveries.courier(:envialia).get_label(tracking_code: 'E000')
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'No hay etiqutas disponibles'
      expect(error.code).to eq 404
    end
  end

  it ".get_labels" do
    # Arrange
    register_envialia_get_label_stubs

    # Success
    # ---

    # Act
    response = Deliveries.courier(:envialia).get_labels(tracking_codes: %w[E001 E002])
    # Assert
    expect(response.url).to eq nil
    expect(pdf_pages_count(response.raw).to_i).to eq 2

    # Error
    # ---

    # Act/Assert
    expect {
      Deliveries.courier(:envialia).get_labels(tracking_codes: %w[E000])
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'No hay etiqutas disponibles'
      expect(error.code).to eq 404
    end

    # Act/Assert
    expect {
      Deliveries.courier(:envialia).get_labels(tracking_codes: %w[E000 E001])
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'No hay etiqutas disponibles'
      expect(error.code).to eq 404
    end
  end
end
