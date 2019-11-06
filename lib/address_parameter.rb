# frozen_string_literal: true

# This class represents an address in Rosette API.
class AddressParameter
  # house (optional)
  attr_accessor :house
  # house_number (optional)
  attr_accessor :house_number
  # road (optional)
  attr_accessor :road
  # unit (optional)
  attr_accessor :unit
  # level (optional)
  attr_accessor :level
  # staircase (optional)
  attr_accessor :staircase
  # entrance (optional)
  attr_accessor :entrance
  # suburb (optional)
  attr_accessor :suburb
  # city_district (optional)
  attr_accessor :city_district
  # city (optional)
  attr_accessor :city
  # island (optional)
  attr_accessor :island
  # state_district (optional)
  attr_accessor :state_district
  # state (optional)
  attr_accessor :state
  # country_region (optional)
  attr_accessor :country_region
  # country (optional)
  attr_accessor :country
  # world_region (optional)
  attr_accessor :world_region
  # post_code (optional)
  attr_accessor :post_code
  # po_box (optional)
  attr_accessor :po_box

  def initialize(options = {}) #:notnew:
    options = {
      house: nil,
      house_number: nil,
      road: nil,
      unit: nil,
      level: nil,
      staircase: nil,
      entrance: nil,
      suburb: nil,
      city_district: nil,
      city: nil,
      island: nil,
      state_district: nil,
      state: nil,
      country_region: nil,
      country: nil,
      world_region: nil,
      post_code: nil,
      po_box: nil
    }.update options
    @house = options[:house]
    @house_number = options[:house_number]
    @road = options[:road]
    @unit = options[:unit]
    @level = options[:level]
    @staircase = options[:staircase]
    @entrance = options[:entrance]
    @suburb = options[:suburb]
    @city_district = options[:city_district]
    @city = options[:city]
    @island = options[:island]
    @state_district = options[:state_district]
    @state = options[:state]
    @country_region = options[:country_region]
    @country = options[:country]
    @world_region = options[:world_region]
    @post_code = options[:post_code]
    @po_box = options[:po_box]
  end

  # Converts this class to Hash with its keys in lower CamelCase.
  #
  # Returns the new Hash.
  def load_param
    to_hash.select { |_key, value| value }
           .map { |key, value| [key.to_s.split('_').map(&:capitalize).join.sub!(/\D/, &:downcase), value] }
           .to_h
  end

  # Converts this class to Hash.
  #
  # Returns the new Hash.
  def to_hash
    {
      house: @house,
      house_number: @house_number,
      road: @road,
      unit: @unit,
      level: @level,
      staircase: @staircase,
      entrance: @entrance,
      suburb: @suburb,
      city_district: @city_district,
      city: @city,
      island: @island,
      state_district: @state_district,
      state: @state,
      country_region: @country_region,
      country: @country,
      world_region: @world_region,
      post_code: @post_code,
      po_box: @po_box
    }
  end
end
