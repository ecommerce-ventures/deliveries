module Deliveries
  module Couriers
    module Ups
      module Shipments
        class Create
          include JsonRequest
          include LabelUtils

          API_VERSION = 'v1807'.freeze
          TYPES = %i[forward return].freeze

          attr_accessor :shipper, :consignee, :parcels, :reference_code, :type, :collection_point, :language

          def initialize(shipper:, consignee:, parcels:, reference_code:, type: :forward, collection_point: nil, language: nil)
            raise ArgumentError, 'Invalid value for type' unless TYPES.include?(type)

            self.shipper = shipper
            self.consignee = consignee
            self.parcels = parcels
            self.reference_code = reference_code
            self.collection_point = collection_point
            self.type = type
            self.language = language&.to_sym&.downcase || :en
          end

          def execute
            request = {
              ShipmentRequest: {
                Request: {
                  RequestOption: 'nonvalidate'
                },
                Shipment: {
                  Description: Ups.config('default_product.description', default: 'International Goods'),

                  Shipper: shipper_address(with_number: true),

                  PaymentInformation: {
                    ShipmentCharge: {
                      Type: '01',
                      BillShipper: {
                        AccountNumber: account_number
                      }
                    }
                  },

                  ReferenceNumber: {
                    Code: 'ON',
                    Value: reference_code
                  },

                  Service: {
                    Code: '11',
                    Description: 'Standard'
                  },

                  Package: package_data,

                  LabelSpecification: {
                    LabelImageFormat: {
                      Code: 'GIF'
                    }
                  }
                }
              }
            }

            if type == :return
              request[:ShipmentRequest][:Shipment][:ReturnService] = { Code: '9' }
              request[:ShipmentRequest][:Shipment][:ShipFrom] = consignee_address
              request[:ShipmentRequest][:Shipment][:ShipTo] = shipper_address
            else # forward
              request[:ShipmentRequest][:Shipment][:ShipFrom] = shipper_address
              request[:ShipmentRequest][:Shipment][:ShipTo] = consignee_address

              if collection_point?
                request[:ShipmentRequest][:Shipment][:ShipmentIndicationType] = {
                  Code: '01',
                  Description: 'DirectToRetail'
                }
                request[:ShipmentRequest][:Shipment][:AlternateDeliveryAddress] = collection_point_address
                request[:ShipmentRequest][:Shipment][:ShipmentServiceOptions] = {
                  Notification: {
                    NotificationCode: '012',
                    EMail: {
                      EMailAddress: consignee.email
                    },
                    Locale: {
                      Language: locale_language,
                      Dialect: locale_dialect
                    }
                  }
                }
              end
            end

            response = call request

            tracking_code = response.dig(:ShipmentResponse, :ShipmentResults, :ShipmentIdentificationNumber)
            labels = [response.dig(:ShipmentResponse, :ShipmentResults, :PackageResults)].flatten.map do |p|
              encoded_gif = p.dig(:ShippingLabel, :GraphicImage)
              image2pdf Base64.decode64(encoded_gif).force_encoding('binary'), height: 4
            end

            {
              tracking_code: tracking_code,
              label: labels.one? ? labels.first : merge_pdfs(labels)
            }
          end

          private

          def api_endpoint
            if Ups.live?
              "https://onlinetools.ups.com/ship/#{API_VERSION}/shipments"
            else
              "https://wwwcie.ups.com/ship/#{API_VERSION}/shipments"
            end
          end

          def collection_point?
            !@collection_point.nil?
          end

          def account_number
            if collection_point?
              Ups.config(:point_account_number)
            else
              Ups.config(:home_account_number)
            end
          end

          def locale_language
            case language
            when :es then 'SPA'
            when :fr then 'FRA'
            when :pt then 'POR'
            when :it then 'ITA'
            when :de then 'DEU'
            when :pl then 'POL'
            else 'ENG'
            end
          end

          def locale_dialect
            if language == :en
              'GB'
            else
              '97'
            end
          end

          def package_data
            parcels.times.map do
              {
                Description: Ups.config('default_product.description', default: 'International Goods'),
                Packaging: {
                  Code: '02',
                  Description: 'Customer Supplied'
                },
                PackageWeight: {
                  UnitOfMeasurement: {
                    Code: 'KGS'
                  },
                  Weight: Ups.config('default_product.weight', default: '1')
                }
              }
            end
          end

          def shipper_address(with_number: false)
            address = format_address shipper
            address[:ShipperNumber] = account_number if with_number

            address
          end

          def consignee_address
            format_address consignee
          end

          def collection_point_address
            address = format_address collection_point
            address[:UPSAccessPointID] = collection_point.point_id
            address.delete :Phone
            address.delete :EMailAddress

            address
          end

          def format_address(address)
            {
              Name: I18n.transliterate(address.name)[0, 35],
              AttentionName: I18n.transliterate(address.name)[0, 35],
              Phone: {
                Number: address.phone
              },
              EMailAddress: address.email,
              Address: {
                AddressLine: I18n.transliterate(address.street).scan(/.{1,35}/)[0, 3],
                City: I18n.transliterate(address.city)[0, 30],
                PostalCode: address.postcode.to_s[0, 9],
                CountryCode: address.country.to_s.downcase[0, 2]
              }
            }
          end
        end
      end
    end
  end
end
