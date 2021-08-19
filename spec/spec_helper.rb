# frozen_string_literal: true

require 'savon'
require 'rspec'
require 'webmock/rspec'
require 'savon/mock/spec_helper'
require 'hexapdf'
require 'active_support/time'

Dir["#{File.expand_path("../", __dir__)}/spec/support/**/*.rb"].each.each { |f| require f }

RSpec.configure do |config|
  config.include SpecHelpers
  config.include DeliveriesConfig

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Configure time zone
  Time.zone = 'Madrid'
end
