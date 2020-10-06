module Deliveries
  class Address
    attr_accessor :name, :email, :phone, :country, :state, :city, :street, :postcode

    COUNTRY_PHONE_PREFIXES = {
      be: 32,
      fr: 33,
      es: 34,
      it: 39,
      gb: 44,
      de: 49,
      pt: 351
    }.freeze
    COUNTRY_TRUNK_PREFIXES = {
      be: 0,
      fr: 0,
      es: nil,
      it: nil,
      gb: 0,
      de: 0,
      pt: nil
    }.freeze

    def initialize(**attributes)
      self.name = attributes[:name]
      self.email = attributes[:email]
      self.phone = attributes[:phone]
      self.country = attributes[:country]
      self.state = attributes[:state]
      self.city = attributes[:city]
      self.street = attributes[:street]
      self.postcode = attributes[:postcode]
    end

    def courierize(courier_id)
      courier_address = %(Deliveries::Couriers::#{courier_id.to_s.camelize}::Address).safe_constantize.new
      instance_variables.each do |iv|
        courier_address.instance_variable_set(iv, instance_variable_get(iv))
      end
      courier_address
    end

    protected

    def format_international_phone
      return '' if @phone.blank? || @country.blank?

      country = @country.downcase.to_sym
      prefix = COUNTRY_PHONE_PREFIXES[country]
      trunk_prefix = COUNTRY_TRUNK_PREFIXES[country]

      # Remove white spaces.
      tmp_phone = @phone.gsub(' ', '')

      # Remove current prefix if present.
      tmp_phone.gsub!(/\A(00|\+)#{prefix}/, '')

      # Remove trunk prefix to convert it to international.
      tmp_phone.gsub!(/\A#{trunk_prefix}/, '') if trunk_prefix

      "+#{prefix}#{tmp_phone}"
    end

    def format_email
      return '' if @email.blank?

      matches = @email.split(/[+@]/)
      %(#{matches.first}@#{matches.last})
    end
  end
end
