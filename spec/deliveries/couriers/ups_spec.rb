require 'deliveries/support/ups_stubs'

RSpec.describe "Ups" do
  it ".get_collection_point" do
    # Arrange
    register_ups_get_collection_point_stubs
    #
    # Success
    # ---
    #
    # Act
    response = Deliveries.courier(:ups).get_collection_point(global_point_id: 'ups~it~10141~U78267940')

    # Assert
    collection_point = response
    expect(collection_point).to be_a Deliveries::CollectionPoint
    expect(collection_point.courier_id).to eq :ups
    expect(collection_point.name).to eq 'FOTOCELL'
    expect(collection_point.point_id).to eq 'U78267940'
    expect(collection_point.street).to eq 'CORSO RACCONIGI 164 B'
    expect(collection_point.city).to eq 'TORINO'
    expect(collection_point.postcode).to eq '10141'
    expect(collection_point.latitude).to eq "45.05980682"
    expect(collection_point.longitude).to eq "7.645729064"
    expect(collection_point.timetable).to be_a Hash
    expect(collection_point.timetable.length).to eq 7
    expect(collection_point.timetable[0]).to eq [OpenStruct.new(open: '9:30', close: '12:30'), OpenStruct.new(open: '15:00', close: '18:00')]
    expect(collection_point.email).to eq nil
    expect(collection_point.phone).to eq "0230303039"
    expect(collection_point.country).to eq "it"
    expect(collection_point.state).to eq "TORINO"

    # Error
    # ---

    # Act/Assert
    expect {
      Deliveries.courier(:ups).get_collection_point(global_point_id: 'ups~it~10141~U782679401')
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'Unable to find any locations.'
      expect(error.code).to eq "350201"
    end
  end

  it ".get_collection_points" do
    # Arrange
    register_ups_get_collection_points_stubs

    # Success
    # ---

    # Act
    response = Deliveries.courier(:ups).get_collection_points(postcode: '10141', country: 'it')
    # Assert
    expect(response).to be_a Array
    collection_point = response.first
    expect(collection_point).to be_a Deliveries::CollectionPoint
    expect(collection_point.courier_id).to eq :ups
    expect(collection_point.name).to eq 'FOTOCELL'
    expect(collection_point.point_id).to eq 'U78267940'
    expect(collection_point.street).to eq 'CORSO RACCONIGI 164 B'
    expect(collection_point.city).to eq 'TORINO'
    expect(collection_point.postcode).to eq '10141'
    expect(collection_point.latitude).to eq "45.05980682"
    expect(collection_point.longitude).to eq "7.645729064"
    expect(collection_point.timetable).to be_a Hash
    expect(collection_point.timetable.length).to eq 7
    expect(collection_point.timetable[0]).to eq [OpenStruct.new(open: '9:30', close: '12:30'), OpenStruct.new(open: '15:00', close: '18:00')]
    expect(collection_point.email).to eq nil
    expect(collection_point.phone).to eq "0230303039"
    expect(collection_point.country).to eq "it"
    expect(collection_point.state).to eq "TORINO"
    #
    # # Error
    # # ---
    #
    # # Act/Assert
    # expect {
    #   Deliveries.courier(:correos_express).get_collection_points(postcode: '')
    # }.to raise_error(Deliveries::APIError) do |error|
    #   expect(error.message).to eq 'Postcode cannot be null'
    #   expect(error.code).to eq nil
    # end
    #
    # # Act/Assert
    # expect {
    #   Deliveries.courier(:correos_express).get_collection_points(postcode: '1')
    # }.to raise_error(Deliveries::APIError) do |error|
    #   expect(error.message).to eq 'java.lang.NullPointerException - null'
    #   expect(error.code).to eq '500'
    # end
  end

  it ".create_shipment" do
    # Arrange
    register_ups_create_shipment_stubs

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
    response = Deliveries.courier(:ups).create_shipment(
      sender: sender,
      receiver: receiver,
      collection_point: nil,
      parcels: 1,
      reference_code: 'shipmentX',
      shipment_date: Date.tomorrow,
      remarks: nil
    )

    # Assert
    expect(response).to be_a Deliveries::Shipment
    expect(response.courier_id).to eq :ups
    expect(response.sender).to eq sender
    expect(response.receiver).to eq receiver
    expect(response.parcels).to eq 1
    expect(response.reference_code).to eq 'shipmentX'
    expect(response.tracking_code).to eq '1ZW673A16814843169'
    expect(response.shipment_date).to eq Date.tomorrow
    expect(response.label.raw).to start_with '%PDF-'

    # Error
    # ---

    # Arrange
    receiver.name = ''

    # Act/Assert
    expect {
      Deliveries.courier(:ups).create_shipment(
        sender: sender,
        receiver: receiver,
        collection_point: nil,
        parcels: 1,
        reference_code: 'shipmentX',
        shipment_date: Date.tomorrow,
        remarks: nil
      )
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'Missing or invalid ship to company name'
      expect(error.code).to eq 120200
    end
  end

  it ".create_pickup" do
    # Arrange
    register_ups_create_pickup_stubs
    #
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
    response = Deliveries.courier(:ups).create_pickup(
      sender: sender,
      receiver: receiver,
      parcels: 1,
      reference_code: 'shipmentX',
      pickup_date: Date.tomorrow,
      remarks: nil
    )

    # Assert
    expect(response).to be_a Deliveries::Pickup
    expect(response.courier_id).to eq :ups
    expect(response.sender).to eq sender
    expect(response.receiver).to eq receiver
    expect(response.parcels).to eq 1
    expect(response.reference_code).to eq 'shipmentX'
    expect(response.tracking_code).to eq '1ZW673A16814843169'
    expect(response.pickup_date).to eq Date.tomorrow

    # Error
    # ---

    # Arrange
    sender.name = ''

    # Act/Assert
    expect {
      Deliveries.courier(:ups).create_pickup(
        sender: sender,
        receiver: receiver,
        parcels: 1,
        reference_code: 'shipmentX',
        pickup_date: Date.tomorrow,
        remarks: nil
      )
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'Missing or invalid shipper name'
      expect(error.code).to eq 120101
    end
  end

  it ".get_label" do
    # Arrange
    register_ups_get_label_stubs

    # Success
    # ---

    # Act
    response = Deliveries.courier(:ups).get_label(tracking_code: '1Ztest016814843169')
    # Assert
    expect(response.url).to eq "https://www.ups.com/uel/llp/1Z12345E8791315413/link/labelAll/XLBR/pAlSXbgkQyOxWyYge8Ousaqnwh14qiIZi1wR8p17iAAe/en_US?loc=en_US&cie=true&pdr=false"
    expect(pdf_pages_count(response.raw).to_i).to eq 1

    # Error
    # ---

    # Act/Assert
    expect {
      Deliveries.courier(:ups).get_labels(tracking_codes: %w[1Ztest016814843170])
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'The shipment for the requested tracking number or the combination of reference number plus shipper number could not be found. Please check the submitted data or wait until the shipment is processed.'
      expect(error.code).to eq 9801031
    end
  end

  it ".get_labels" do
    # Arrange
    register_ups_get_labels_stubs
    #
    # Success
    # ---

    # Act
    response = Deliveries.courier(:ups).get_labels(tracking_codes: %w[1Ztest016814843169])
    # Assert
    expect(response.url).to eq nil
    expect(pdf_pages_count(response.raw).to_i).to eq 1

    # Act/Assert
    expect {
      Deliveries.courier(:ups).get_labels(tracking_codes: %w[1Ztest016814843170])
    }.to raise_error(Deliveries::APIError) do |error|
      expect(error.message).to eq 'The shipment for the requested tracking number or the combination of reference number plus shipper number could not be found. Please check the submitted data or wait until the shipment is processed.'
      expect(error.code).to eq 9801031
    end
  end

  it ".shipment_info" do
    # Arrange
    register_ups_shipment_info_stubs
    #
    # Success
    # ---

    # Act
    response = Deliveries.courier(:ups).shipment_info(tracking_code: '1ZW673A16814843169')
    # Assert
    expect(response).to be_a Deliveries::TrackingInfo
    expect(response.courier_id).to eq :ups
    expect(response.tracking_code).to eq 'XXXXXX'
    expect(response.url).to eq nil
    expect(response.status).to eq :registered
    expect(response.checkpoints).to be_a Array
    checkpoint = response.checkpoints.first
    expect(checkpoint).to be_a Deliveries::Checkpoint
    expect(checkpoint.status).to eq :registered
    expect(checkpoint.location).to eq nil
    expect(checkpoint.tracked_at).to eq "#{Date.current} 11:12:13".in_time_zone('CET')
    expect(checkpoint.description).to eq "SIN RECEPCION"
    #
    # # Error
    # # ---
    #
    # # Act/Assert
    # expect {
    #   Deliveries.courier(:correos_express).shipment_info(tracking_code: 'E000')
    # }.to raise_error(Deliveries::APIError) do |error|
    #   expect(error.message).to eq 'ERROR EN BBDD - NO SE HAN ENCONTRADO DATOS'
    #   expect(error.code).to eq "402"
    # end
  end

  it ".pickup_info" do
    # Arrange
    register_ups_pickup_info_stubs
    #
    # Success
    # ---

    # Act
    response = Deliveries.courier(:ups).pickup_info(tracking_code: 'E001')
    # Assert
    expect(response).to be_a Deliveries::TrackingInfo
    expect(response.courier_id).to eq :ups
    expect(response.tracking_code).to eq 'E001'
    expect(response.url).to eq nil
    expect(response.status).to eq :delivered
    expect(response.checkpoints).to be_a Array
    expect(response.checkpoints.length).to eq 3
    expect(response.checkpoints[0]).to be_a Deliveries::Checkpoint
    expect(response.checkpoints[0].status).to eq :registered
    expect(response.checkpoints[0].location).to eq nil
    expect(response.checkpoints[0].tracked_at).to eq "#{Date.yesterday} 11:11:11".in_time_zone
    expect(response.checkpoints[0].description).to eq 'PDTE ASIGNAR'
    expect(response.checkpoints[1]).to be_a Deliveries::Checkpoint
    expect(response.checkpoints[1].status).to eq :in_transit
    expect(response.checkpoints[1].location).to eq nil
    expect(response.checkpoints[1].tracked_at).to eq "#{Date.current} 13:13:13".in_time_zone
    expect(response.checkpoints[1].description).to eq 'TRANSMITIDA'
    expect(response.checkpoints[2]).to be_a Deliveries::Checkpoint
    expect(response.checkpoints[2].status).to eq :delivered
    expect(response.checkpoints[2].location).to eq nil
    expect(response.checkpoints[2].tracked_at).to eq "#{Date.current} 15:15:15".in_time_zone
    expect(response.checkpoints[2].description).to eq 'EFECTUADA'
    #
    # # Error
    # # ---
    #
    # # Act/Assert
    # expect {
    #   Deliveries.courier(:correos_express).pickup_info(tracking_code: 'E000')
    # }.to raise_error(Deliveries::APIError) do |error|
    #   expect(error.message).to eq 'NO SE ENCUENTRA LA RECOGIDA'
    #   expect(error.code).to eq nil
    # end
  end
end
