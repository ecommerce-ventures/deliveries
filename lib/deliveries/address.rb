module Deliveries
  class Address
    attr_accessor :name, :email, :phone, :country, :state, :city, :street, :postcode

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
  end
end
