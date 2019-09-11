# "codigoOficina"=>"4894006",
# "nombreOficina"=>"OF.CORREOS: LAMIAKO - 4894006",
# "direccionOficina"=>"LANGILERIA 88",
# "codigoPostalOficina"=>"48940",
# "poblacionOficina"=>"LAMIAKO",
# "horarioOficina"=>"L-V:DE 08:30 A 14:30/S:DE 09:30 A 13:00/Festivos:SIN SERVICIO",
# "horarioOficinaVerano"=>"L-V:08:30-14:30/S:09:30-13:00/Festivos:SIN SERVICIO",
# "geoposicionOficina"=>"43.32142,-3.00031"

module Deliveries
  module Couriers
    module CorreosExpress
      module CollectionPoints
        class Search
          class FormatResponse
            SATURDAY_HOUR_KEY = "S:".freeze
            WORKDAY_HOUR_KEY = "L-V:".freeze
            HOLIDAY_HOUR_KEY = "Festivos:".freeze

            attr_accessor :response

            def initialize(response:)
              self.response = response
            end

            def execute
              collection_point = {}
              collection_point[:courier_id] = 'correos_express'
              collection_point[:name] = response['nombreOficina']
              collection_point[:point_id] = response['codigoOficina']
              collection_point[:street] = response['direccionOficina']
              collection_point[:city] = response['poblacionOficina']
              collection_point[:postcode] = response['codigoPostalOficina']
              latitude, longitude = response['geoposicionOficina'].split(",")
              collection_point[:latitude] = latitude.to_f
              collection_point[:longitude] = longitude.to_f
              collection_point[:timetable] = formatted_timetable(response['horarioOficina'])

              collection_point
            end

            private

            def formatted_timetable(params)
              workday_hour, saturday_hour, holiday_hour = get_week_hours_from_result(params)

              timetable = {}

              if workday_hour.present?
                1.upto(5) do |weekday|
                  timetable[weekday] = [formatted_slot(workday_hour, WORKDAY_HOUR_KEY)]
                end
              end

              if saturday_hour.present?
                timetable[6] = [formatted_slot(saturday_hour, SATURDAY_HOUR_KEY)]
              end

              if holiday_hour.present?
                timetable[0] = nil
              end

              timetable
            end

            def get_week_hours_from_result(params)
              week_hours = params.split("/")

              workday_hour = week_hours.select{ |o| o.start_with?(WORKDAY_HOUR_KEY) }.first
              saturday_hour = week_hours.select{ |o| o.start_with?(SATURDAY_HOUR_KEY) }.first
              holiday_hour = week_hours.select{ |o| o.start_with?(HOLIDAY_HOUR_KEY) }.first

              [workday_hour, saturday_hour, holiday_hour]
            end

            def formatted_slot(hour, key)
              open, close = hour.sub(key, '').sub('DE ', '').split(' A ')

              OpenStruct.new(open: open, close: close)
            end
          end
        end
      end
    end
  end
end
