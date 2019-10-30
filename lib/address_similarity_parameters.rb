require_relative 'bad_request_error'
require_relative 'address_parameter'

# This class encapsulates parameters that are needed for address-similarity in
# Rosette API.
class AddressSimilarityParameters
  # Address to be compared to address2
  attr_accessor :address1
  # Address to be compared to address1
  attr_accessor :address2

  def initialize(address1, address2) #:notnew:
    @address1 = address1
    @address2 = address2
  end

  # Validates the parameters by checking if address1 and address2 are instances of AddressParameter.
  def validate_params
    raise BadRequestError.new('address1 option can only be an instance of an AddressParameter') if [AddressParameter].none? { |clazz| @address1.is_a? clazz }
    raise BadRequestError.new('address2 option can only be an instance of an AddressParameter') if [AddressParameter].none? { |clazz| @address2.is_a? clazz }
  end

  # Converts this class to Hash with its keys in lower CamelCase.
  #
  # Returns the new Hash.
  def load_params
    validate_params
    to_hash.reject { |_key, value| value.nil? }
           .map { |key, value| [key.to_s.split('_').map(&:capitalize).join.sub!(/\D/, &:downcase), value] }
           .to_h
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
