# frozen_string_literal: true

require_relative 'lib/deliveries/version'

Gem::Specification.new do |spec|
  spec.name          = 'deliveries'
  spec.version       = Deliveries::VERSION
  spec.authors       = ['Fran Vega', 'Raúl Rodríguez', 'Roberto Martínez', 'Pedro Guerra']
  spec.email         = ['admin@micolet.com']

  spec.summary       = 'Library to abstract multiple courier web services.'
  spec.homepage      = 'https://github.com/ecommerce-ventures/deliveries'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.7')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/ecommerce-ventures/deliveries'
  spec.metadata['changelog_uri'] = 'https://github.com/ecommerce-ventures/deliveries/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 5.2.0'
  spec.add_dependency 'hexapdf'
  spec.add_dependency 'httparty'
  spec.add_dependency 'mini_magick'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'savon', '~> 2.8'

  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'webmock', '~> 3.5'
end
