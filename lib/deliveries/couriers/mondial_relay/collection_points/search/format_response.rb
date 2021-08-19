# :stat=>"0",
# :num=>"070912",
# :lg_adr1=>"VENANDCOM                      ",
# :lg_adr2=>nil,
# :lg_adr3=>"CL LANGILERIA 126              ",
# :lg_adr4=>nil,
# :cp=>"48940",
# :ville=>"LEIOA                     ",
# :pays=>"ES",
# :localisation1=>"ENTRE METRO LAMIACO Y ROMO    ",
# :localisation2=>nil,
# :horaires_lundi=>{:string=>["1000", "1330", "1700", "2000"]},
# :horaires_mardi=>{:string=>["1000", "1330", "1700", "2000"]},
# :horaires_mercredi=>{:string=>["1000", "1330", "1700", "2000"]},
# :horaires_jeudi=>{:string=>["1000", "1330", "1700", "2000"]},
# :horaires_vendredi=>{:string=>["1000", "1330", "1700", "2000"]},
# :horaires_samedi=>{:string=>["1000", "1330", "0000", "0000"]},
# :horaires_dimanche=>{:string=>["0000", "0000", "0000", "0000"]},
# :information=>nil,
# :url_photo=>"https://ww2.mondialrelay.com/public/permanent/photo_relais.aspx?ens=CC______41&num=070912&pays=ES&crc=17576B6AE31EA66C7C66463BCDD955A4",
# :url_plan=>"https://ww2.mondialrelay.com/public/permanent/plan_relais.aspx?ens=test11&num=070912&pays=ES&crc=4F83CD143A1506242F025F9C11311A3C"}

# Deliveries.courier('mondial_relay').get_collection_point(point_id: 23191, country: 'ES')

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

              point
            end

            private

            def formatted_timetable(result)
              timetable = {}

              week_hours = get_week_hours_from_result(result)
              week_hours.each do |i, times|
                timetable[i] = []
                if times[0] == '0000'
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
              OpenStruct.new(open: open.insert(2, ':'), close: close.insert(2, ':'))
            end
          end
        end
      end
    end
  end
end
