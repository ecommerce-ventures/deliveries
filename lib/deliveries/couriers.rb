module Deliveries
  module Couriers
    Dir[File.dirname(__FILE__) + '/couriers/*.rb'].each do |f|
      # Get camelized class name
      filename = File.basename(f, '.rb')

      # Camelize the string to get the class name
      courier_class = filename.split('_').map(&:capitalize).join.to_sym

      # Register for autoloading
      autoload courier_class, f
    end
  end
end
