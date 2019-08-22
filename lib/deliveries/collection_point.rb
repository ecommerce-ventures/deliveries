module Deliveries
  class CollectionPoint < Address
    attr_accessor :courier_id, :point_id, :latitude, :longitude, :timetable, :url_map, :url_photo

    def initialize(**attributes)
      super(attributes)

      self.courier_id = attributes[:courier_id]
      self.point_id = attributes[:point_id]
      self.latitude = attributes[:latitude]
      self.longitude = attributes[:longitude]
      self.timetable = attributes[:timetable]
      self.url_map = attributes[:url_map]
      self.url_photo = attributes[:url_photo]
    end

    def global_point_id
      "#{courier_id}~#{country}~#{postcode}~#{point_id}"
    end

    def self.parse_global_point_id(global_point_id:)
      global_point = global_point_id.split('~')

      OpenStruct.new(
        courier_id: global_point[0],
        country: global_point[1],
        postcode: global_point[2],
        point_id: global_point[3]
      )
    end
  end
end
