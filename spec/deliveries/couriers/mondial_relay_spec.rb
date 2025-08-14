require 'deliveries/support/mondial_relay_stubs'

RSpec.describe "Mondial Relay" do
  include Savon::SpecHelper

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
    expect(collection_point.timetable[1].first).to be_instance_of(Deliveries::CollectionPoint::TIMETABLE_SLOT)
    expect(collection_point.timetable[1].map(&:to_h)).to eq [{ open: '09:30', close: '15:30' }]
    expect(collection_point.timetable[2].map(&:to_h)).to eq [{ open: '09:30', close: '19:30' }]
    expect(collection_point.timetable[3].map(&:to_h)).to eq [{ open: '09:30', close: '19:30' }]
    expect(collection_point.timetable[4].map(&:to_h)).to eq [{ open: '09:30', close: '19:30' }]
    expect(collection_point.timetable[5].map(&:to_h)).to eq [{ open: '09:30', close: '19:30' }]
    expect(collection_point.timetable[6].map(&:to_h)).to eq [{ open: '09:30', close: '18:30' }]
    expect(collection_point.email).to eq nil
    expect(collection_point.phone).to eq nil
    expect(collection_point.country).to eq 'FR'
    expect(collection_point.state).to eq nil
    expect(collection_point.locker).to be_truthy

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
    expect(collection_point.timetable[1].first).to be_instance_of(Deliveries::CollectionPoint::TIMETABLE_SLOT)
    expect(collection_point.timetable[1].map(&:to_h)).to eq [{ open: '09:30', close: '15:30' }]
    expect(collection_point.timetable[2].map(&:to_h)).to eq [{ open: '09:30', close: '19:30' }]
    expect(collection_point.timetable[3].map(&:to_h)).to eq [{ open: '09:30', close: '19:30' }]
    expect(collection_point.timetable[4].map(&:to_h)).to eq [{ open: '09:30', close: '19:30' }]
    expect(collection_point.timetable[5].map(&:to_h)).to eq [{ open: '00:00', close: '23:59' }]
    expect(collection_point.timetable[6].map(&:to_h)).to eq [{ open: '09:30', close: '18:30' }]
    expect(collection_point.email).to eq nil
    expect(collection_point.phone).to eq nil
    expect(collection_point.country).to eq 'FR'
    expect(collection_point.state).to eq nil
    expect(collection_point.locker).to be_falsey

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
    expect(checkpoint.tracked_at).to eq "#{Date.yesterday} 10:10:00".in_time_zone('CET')
    expect(checkpoint.description).to eq "RÉCEPTION DES DONNÉES"
    checkpoint = response.checkpoints.last
    expect(checkpoint).to be_a Deliveries::Checkpoint
    expect(checkpoint.status).to eq :in_transit
    expect(checkpoint.location).to eq 'ESPAGNE'
    expect(checkpoint.tracked_at).to eq "#{Date.current} 11:11:00".in_time_zone('CET')
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
