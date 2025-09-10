module Deliveries
  class CollectionPoint < Address
    TIMETABLE_SLOT = Struct.new(:open, :close, keyword_init: true)

    attr_accessor :courier_id, :point_id, :latitude, :longitude, :url_map, :url_photo, :locker
    attr_writer :timetable

    def initialize(**attributes)
      super(**attributes)

      self.courier_id = attributes[:courier_id]
      self.point_id = attributes[:point_id]
      self.latitude = attributes[:latitude]
      self.longitude = attributes[:longitude]
      self.timetable = formatted_timetable(attributes[:timetable])
      self.locker = attributes[:locker]
      self.url_map = attributes[:url_map]
      self.url_photo = attributes[:url_photo]
    end

    def global_point_id
      "#{courier_id}~#{country}~#{postcode}~#{point_id}"
    end

    def timetable(start_day: :monday)
      raise Error, "Invalid week start day: #{start_day}" unless %i[monday sunday].include?(start_day)

      @timetable&.sort_by do |wday, _slots|
        if wday.zero? && start_day == :monday
          7
        else
          wday
        end
      end&.to_h
    end

    def self.parse_global_point_id(global_point_id:)
      global_point = global_point_id.split('~')

      Struct.new(
        :courier_id,
        :country,
        :postcode,
        :point_id
      ).new(*global_point[0, 4])
    end

    private

    def formatted_timetable(timetable)
      timetable&.transform_values do |slots|
        slots&.map(&TIMETABLE_SLOT.method(:new))
      end
    end
  end
end
