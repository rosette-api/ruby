# frozen_string_literal: true

require_relative 'bad_request_error'
require_relative 'address_parameter'

# This class encapsulates parameters that are needed for address-similarity in
# Rosette API.
class AddressSimilarityParameters
  # Address to be compared to address2
  attr_accessor :address1
  # Address to be compared to address1
  attr_accessor :address2

  def initialize(address1, address2) # :notnew:
    @address1 = address1
    @address2 = address2
  end

  # Validates the parameters by checking if address1 and address2 are instances
  # of AddressParameters or Strings.
  def validate_params
    a1_msg = 'address1 option can only be an instance of an AddressParameter or a String'
    raise BadRequestError.new(a1_msg) if [String, AddressParameter].none? { |clazz| @address1.is_a? clazz }

    a2_msg = 'address2 option can only be an instance of an AddressParameter or a String'
    raise BadRequestError.new(a2_msg) if [String, AddressParameter].none? { |clazz| @address2.is_a? clazz }
  end

  # Converts this class to Hash with its keys in lower CamelCase.
  #
  # Returns the new Hash.
  def load_params
    validate_params
    to_hash
      .reject { |_key, value| value.nil? }
      .transform_keys { |key| key.to_s.split('_').map(&:capitalize).join.sub!(/\D/, &:downcase) }
  end

  # Converts this class to Hash.
  #
  # Returns the new Hash.
  def to_hash
    {
      address1: @address1.is_a?(AddressParameter) ? @address1.load_param : @address1,
      address2: @address2.is_a?(AddressParameter) ? @address2.load_param : @address2
    }
  end
end
