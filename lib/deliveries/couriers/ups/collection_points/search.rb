module Deliveries
  module Couriers
    module Ups
      module CollectionPoints
        class Search
          attr_accessor :country, :postcode, :point_id

          def initialize(country:, postcode: nil, point_id: nil)
            raise Error, 'Both postcode and point_id cannot be nil' if postcode.nil? && point_id.nil?

            self.country = country.to_s.downcase
            self.postcode = postcode
            self.point_id = point_id
          end

          def execute
            request_id = SecureRandom.uuid

            access = Nokogiri::XML::Builder.new do |xml|
              xml.AccessRequest('xml:lang': 'en-US') {
                xml.AccessLicenseNumber Ups.config(:license_number)
                xml.UserId Ups.config(:username)
                xml.Password Ups.config(:password)
              }
            end

            locator = Nokogiri::XML::Builder.new do |xml|
              xml.LocatorRequest {
                xml.Request {
                  xml.RequestAction 'Locator'
                  xml.RequestOption '64'
                  xml.TransactionReference {
                    xml.CustomerContext request_id
                    xml.XpciVersion '1.0014'
                  }
                }
                xml.OriginAddress {
                  xml.AddressKeyFormat {
                    xml.SingleLineAddress postcode if postcode
                    xml.CountryCode country.upcase
                  }
                }

                xml.LocationSearchCriteria {
                  xml.AccessPointSearch {
                    xml.AccessPointStatus '01'
                    if point_id
                      xml.PublicAccessPointID point_id
                    else
                      xml.IncludeCriteria {
                        xml.SearchFilter {
                          xml.ShippingAvailabilityIndicator ''
                        }
                      }
                    end
                  }

                  xml.MaximumListSize '20'
                }

                xml.Translate {
                  xml.Locale locale
                }
              }
            end

            request_body = access.to_xml + locator.to_xml

            response = HTTParty.post(
              api_endpoint,
              body: request_body,
              headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
              debug_output: Deliveries.debug ? Deliveries.logger : nil
            )

            response_doc = Nokogiri.XML(response.body)
            response_id = response_doc.at_xpath('//LocatorResponse/Response/TransactionReference/CustomerContext')&.content
            raise Error, 'Request and response ID mismatch' if request_id != response_id

            unless response_doc.at_xpath('//LocatorResponse/Response/ResponseStatusCode')&.content == '1'
              error_code = response_doc.at_xpath('//LocatorResponse/Response/Error/ErrorCode')&.content
              error_description = response_doc.at_xpath('//LocatorResponse/Response/Error/ErrorDescription')&.content

              raise APIError.new(error_description, error_code)
            end

            response_doc.xpath('//LocatorResponse/SearchResults/DropLocation').map do |location_doc|
              timetable = location_doc.xpath('OperatingHours/StandardHours/DayOfWeek').map do |day_doc|
                wday = day_doc.at_xpath('Day')&.content.to_i % 7
                open_hours = day_doc.xpath('OpenHours')&.map(&:content)&.map { |h| h == '0' ? '00:00' : h.insert(-3, ':') } || []
                close_hours = day_doc.xpath('CloseHours')&.map(&:content)&.map { |h| h == '0' ? '00:00' : h.insert(-3, ':') } || []
                hours = open_hours.zip(close_hours).map{ |open, close| OpenStruct.new(open: open, close: close) }

                [wday, hours]
              end.to_h

              {
                courier_id: Ups::COURIER_ID,
                point_id: location_doc.at_xpath('AccessPointInformation/PublicAccessPointID')&.content,
                latitude: location_doc.at_xpath('Geocode/Latitude')&.content,
                longitude: location_doc.at_xpath('Geocode/Longitude')&.content,
                timetable: timetable,
                url_photo: location_doc.at_xpath('AccessPointInformation/ImageURL')&.content,
                name: location_doc.at_xpath('AddressKeyFormat/ConsigneeName')&.content,
                email: location_doc.at_xpath('EMailAddress')&.content,
                phone: location_doc.at_xpath('PhoneNumber')&.content,
                country: location_doc.at_xpath('AddressKeyFormat/CountryCode')&.content&.downcase,
                state: location_doc.at_xpath('AddressKeyFormat/PoliticalDivision1')&.content,
                city: location_doc.at_xpath('AddressKeyFormat/PoliticalDivision2')&.content,
                street: location_doc.at_xpath('AddressKeyFormat/AddressLine')&.content,
                postcode: location_doc.at_xpath('AddressKeyFormat/PostcodePrimaryLow')&.content
              }
            end
          end

          private

          def api_endpoint
            'https://onlinetools.ups.com/ups.app/xml/Locator'
          end

          def locale
            case country
            when 'es' then 'es_ES'
            when 'it' then 'it_IT'
            when 'pt' then 'pt_PT'
            when 'fr' then 'fr_FR'
            when 'de' then 'de_DE'
            when 'gb' then 'en_GB'
            when 'pl' then 'pl_PL'
            else 'en_US'
            end
          end
        end
      end
    end
  end
end
