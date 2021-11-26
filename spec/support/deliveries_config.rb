# frozen_string_literal: true

require 'deliveries'

module DeliveriesConfig
  Deliveries.mode = :test
  Deliveries.logger = Logger.new(File.expand_path("../..", __dir__) + '/deliveries.log')
  Deliveries.debug = true

  # Load configuration file.
  # conf_mondial = 'test'
  Deliveries.courier(:mondial_relay).configure do |config|
    config.mondial_relay_merchant = 'test'
    config.mondial_relay_key = 'test'
  end

  # conf_mondial_dual = 'test'
  Deliveries.courier(:mondial_relay_dual).configure do |config|
    config.dual_carrier_login = 'test'
    config.dual_carrier_password = 'test'
    config.dual_carrier_customer_id = 'test'
    config.countries = {
      fr: {
        home_delivery_mode: 'HOC'
      },
      de: {
        home_delivery_mode: 'HOM'
      },
      gb: {
        home_delivery_mode: 'HOM'
      }
    }
  end

  # conf_correos = 'test'
  Deliveries.courier(:correos_express).configure do |config|
    config.username = 'test'
    config.password = 'test'
    config.client_code = 'test'
    config.shipment_sender_code = 'test'
    config.pickup_receiver_code = 'test'
    config.countries = {
      es: {
        product: '93'
      },
      pt: {
        product: '63'
      }
    }
  end

  Deliveries.courier(:spring).configure do |config|
    config.api_key = 'test'
    config.countries = {
      gb: {
        service: 'TRCK'
      },
      it: {
        service: 'TRCK'
      }
    }
    config.default_product = {
      description: 'ROPA',
      hs_code: '',
      origin_country: 'ES',
      quantity: 1,
      value: 100
    }
  end

  Deliveries.courier(:ups).configure do |config|
    config.license_number = 'test'
    config.username = 'test'
    config.password = 'test'
    config.point_account_number = 'test01'
    config.home_account_number = 'test02'
    config.default_product = {
      description: 'clothes',
      weight: '1'
    }
  end

  Deliveries.courier(:envialia).configure do |config|
    config.username = 'test'
    config.password = 'test'
    config.agency_code = 'test'
  end
end
