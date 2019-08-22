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
  end
end
