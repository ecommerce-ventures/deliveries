module Deliveries
  module Couriers
    module MondialRelay
      module CollectionPoints
        class Search
          class FormatResponse
            WEEKDAYS_STARTING_SUNDAY = %w[
              dimanche
              lundi
              mardi
              mercredi
              jeudi
              vendredi
              samedi
            ].freeze

            attr_accessor :response

            def initialize(response:)
              self.response = response
            end

            def execute
              point = {}

              point[:courier_id] = 'mondial_relay'
              point[:point_id] = response[:num]
              point[:country] = response[:pays]
              point[:city] = response[:ville].strip unless response[:ville].nil?
              point[:postcode] = response[:cp].strip unless response[:cp].nil?
              point[:url_map] = response[:url_plan]
              point[:latitude] = response[:latitude].tr(',', '.').to_f
              point[:longitude] = response[:longitude].tr(',', '.').to_f
              point[:timetable] = formatted_timetable(response)
              point[:url_photo] = response[:url_photo]
              point[:name] = response[:lg_adr1].strip
              point[:street] = response[:lg_adr3].strip
              point[:locker] = response[:information].to_s.downcase.include?('locker')

              point
            end

            private

            def formatted_timetable(result)
              timetable = {}

              week_hours = get_week_hours_from_result(result)
              week_hours.each do |i, times|
                timetable[i] = []
                if times[0] == '0000' && times[1] == '0000'
                  timetable[i] << nil
                else
                  timetable[i] << formatted_slot(open: times[0], close: times[1])
                  timetable[i] << formatted_slot(open: times[2], close: times[3]) if times[2] != '0000'
                end
                timetable[i] = nil unless timetable[i].any?
              end

              timetable
            end

            def get_week_hours_from_result(result)
              week_hours = {}
              WEEKDAYS_STARTING_SUNDAY.each_with_index do |day, i|
                week_hours[i] = result["horaires_#{day}".to_sym][:string]
              end

              week_hours
            end

            def formatted_slot(open:, close:)
              { open: open.insert(2, ':'), close: close.insert(2, ':') }
            end
          end
        end
      end
    end
  end
end
