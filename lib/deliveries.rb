require 'deliveries/label_utils'
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
require 'deliveries/labels'

module Deliveries
  def self.mode
    if instance_variable_defined? :@mode
      instance_variable_get :@mode
    else
      :test
    end
  end

  def self.mode=(mode)
    mode = mode&.to_sym
    raise "Invalid mode #{mode}" unless %i[live test].include?(mode)

    instance_variable_set :@mode, mode
  end

  def self.test?
    mode == :test
  end

  def self.live?
    mode == :live
  end

  def self.logger
    instance_variable_get :@logger
  end

  def self.logger=(logger)
    instance_variable_set :@logger, logger
  end

  def self.debug
    instance_variable_get(:@debug) == true
  end

  def self.debug=(debug)
    instance_variable_set :@debug, debug
  end

  def self.courier(courier_id)
    Couriers.const_get(courier_id.to_s.downcase.split('_').map(&:capitalize).join)
  end

  def self.get_collection_point(global_point_id)
    global_point = CollectionPoint.parse_global_point_id global_point_id: global_point_id
    courier(global_point.courier_id).get_collection_point global_point_id: global_point_id
  end
end
