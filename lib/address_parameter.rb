# This class represents an address in Rosette API.
class AddressParameter
	# house (optional)
        attr_accessor :house
	# houseNumber (optional)
        attr_accessor :houseNumber
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
	# cityDistrict (optional)
        attr_accessor :cityDistrict
	# city (optional)
        attr_accessor :city
	# island (optional)
        attr_accessor :island
	# stateDistrict (optional)
        attr_accessor :stateDistrict
	# state (optional)
        attr_accessor :state
	# countryRegion (optional)
        attr_accessor :countryRegion
	# country (optional)
        attr_accessor :country
	# worldRegion (optional)
        attr_accessor :worldRegion
	# postCode (optional)
        attr_accessor :postCode
	# poBox (optional)
        attr_accessor :poBox

  def initialize(options = {}) #:notnew:
    options = {
        house: nil,
        houseNumber: nil,
        road: nil,
        unit: nil,
        level: nil,
        staircase: nil,
        entrance: nil,
        suburb: nil,
        cityDistrict: nil,
        city: nil,
        island: nil,
        stateDistrict: nil,
        state: nil,
        countryRegion: nil,
        country: nil,
        worldRegion: nil,
        postCode: nil,
        poBox: nil
    }.update options
    @house = options[:house]
    @houseNumber = options[:houseNumber]
    @road = options[:road]
    @unit = options[:unit]
    @level = options[:level]
    @staircase = options[:staircase]
    @entrance = options[:entrance]
    @suburb = options[:suburb]
    @cityDistrict = options[:cityDistrict]
    @city = options[:city]
    @island = options[:island]
    @stateDistrict = options[:stateDistrict]
    @state = options[:state]
    @countryRegion = options[:countryRegion]
    @country = options[:country]
    @worldRegion = options[:worldRegion]
    @postCode = options[:postCode]
    @poBox = options[:poBox]
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
        houseNumber: @houseNumber,
        road: @road,
        unit: @unit,
        level: @level,
        staircase: @staircase,
        entrance: @entrance,
        suburb: @suburb,
        cityDistrict: @cityDistrict,
        city: @city,
        island: @island,
        stateDistrict: @stateDistrict,
        state: @state,
        countryRegion: @countryRegion,
        country: @country,
        worldRegion: @worldRegion,
        postCode: @postCode,
        poBox: @poBox
    }
  end
end
