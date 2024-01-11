# frozen_string_literal: true

require_relative 'bad_request_error'
require_relative 'name_parameter'

# This class encapsulates parameters that are needed for name-similarity in
# Rosette API.
class NameSimilarityParameters
  # genre to categorize the input data
  attr_accessor :genre
  # Rosette API options (optional, should be a hash)
  attr_accessor :rosette_options
  # Name to be compared to name2
  attr_accessor :name1
  # Name to be compared to name1
  attr_accessor :name2

  def initialize(name1, name2, options = {}) # :notnew:
    options = {
      genre: nil,
      rosette_options: nil
    }.update options
    @genre = options[:genre]
    @name1 = name1
    @name2 = name2
    @rosette_options = options[:rosette_options]
  end

  # Validates the parameters by checking if name1 and name2 are instances of
  # a String or NameParameter.
  def validate_params
    n1_msg = 'name1 option can only be an instance of a String or NameParameter'
    raise BadRequestError.new(n1_msg) if [String, NameParameter].none? { |clazz| @name1.is_a? clazz }

    n2_msg = 'name2 option can only be an instance of a String or NameParameter'
    raise BadRequestError.new(n2_msg) if [String, NameParameter].none? { |clazz| @name2.is_a? clazz }

    opt_msg = 'rosette_options can only be an instance of a Hash'
    raise BadRequestError.new(opt_msg) if @rosette_options && !(@rosette_options.is_a? Hash)
  end

  # Converts this class to Hash with its keys in lower CamelCase.
  #
  # Returns the new Hash.
  def load_params
    validate_params
    to_hash
      .reject { |_key, value| value.nil? }
      .map { |key, value| [key.to_s.split('_').map(&:capitalize).join.sub!(/\D/, &:downcase), value] }
      .to_h
  end

  # Converts this class to Hash.
  #
  # Returns the new Hash.
  def to_hash
    {
      genre: @genre,
      name1: @name1.is_a?(NameParameter) ? @name1.load_param : @name1,
      name2: @name2.is_a?(NameParameter) ? @name2.load_param : @name2,
      options: @rosette_options
    }
  end
end
