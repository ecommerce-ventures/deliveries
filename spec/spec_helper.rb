# frozen_string_literal: true
require 'savon'
require 'rspec'
require 'deliveries'
require 'active_support/all'
require 'webmock/rspec'
require 'savon/mock/spec_helper'
require 'hexapdf'
require 'active_support/core_ext/time'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  Deliveries.mode = :test
  # Deliveries.logger = Logger.new(File.expand_path(File.dirname(__FILE__) +  '/log/deliveries.log'))
  Deliveries.debug = true

  # Load configuration file.
  conf_mondial = 'test'
  Deliveries.courier(:mondial_relay).configure do |config|
    config.mondial_relay_merchant = 'test'
    config.mondial_relay_key = 'test'
  end

  conf_mondial_dual = 'test'
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

  conf_correos = 'test'
  Deliveries.courier(:correos_express).configure do |config|
    config.username = 'micolet_ws'
    config.password = 'LJWt2'
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
    config.point_account_number = 'test'
    config.home_account_number = 'test'
    config.default_product = {
      description: 'clothes',
      weight: '1'
    }
  end

  def pdf_pages_count(file_contents)
    file = Tempfile.new(['tmpfile', '.pdf'], encoding: 'ascii-8bit')
    file.write(file_contents)
    file.close
    %x(pdfinfo "#{file.path}" | grep Pages | sed 's/[^0-9]*//').to_i
  end

  Time.zone = 'Madrid'
end
