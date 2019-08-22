require 'deliveries/address'
require 'deliveries/checkpoint'
require 'deliveries/collection_point'
require 'deliveries/courier'
require 'deliveries/couriers'
require 'deliveries/delivery'
require 'deliveries/errors'
require 'deliveries/pickup'
require 'deliveries/shipment'
require 'deliveries/tracking_info'
require 'deliveries/label'

module Deliveries
  def self.mode
    if class_variable_defined? :@@mode
      class_variable_get :@@mode
    else
      :test
    end
  end

  def self.mode=(mode)
    mode = mode&.to_sym
    raise "Invalid mode #{mode}" unless %i[live test].include?(mode)

    class_variable_set :@@mode, mode
  end

  def self.test?
    mode == :test
  end

  def self.live?
    mode == :live
  end

  def self.courier(courier_id)
    Couriers.const_get(courier_id.to_s.downcase.split('_').map(&:capitalize).join)
  end
end
