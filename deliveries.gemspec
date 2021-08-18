# frozen_string_literal: true

require_relative "lib/deliveries/version"

Gem::Specification.new do |spec|
  spec.name          = "deliveries"
  spec.version       = Deliveries::VERSION
  spec.authors       = ["Pedro Guerra"]
  spec.email         = ["pdrowr@gmail.com"]

  spec.summary       = "Write a short summary, because RubyGems requires one."
  spec.description   = "Write a longer description or delete this line."
  spec.homepage      = "https://github.com/ecommerce-ventures/deliveries"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.7")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ecommerce-ventures/deliveries"
  spec.metadata["changelog_uri"] = "https://github.com/ecommerce-ventures/deliveries"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'rspec-rails', '~> 3.4'
  spec.add_dependency 'mini_magick'
  spec.add_dependency 'hexapdf'
  spec.add_dependency 'savon', '~> 2.8'
  spec.add_dependency 'httparty'
  spec.add_dependency 'webmock', '~> 3.5'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'byebug'


  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
