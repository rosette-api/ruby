# frozen_string_literal: true

require_relative 'bad_request_error'
require_relative 'name_parameter'

# This class encapsulates parameters that are needed for name-similarity in
# Analytics API.
class NameSimilarityParameters
  # genre to categorize the input data
  attr_accessor :genre
  # Deprecated: Retained for backward compatibility. Use 'parameters' instead.
  # Rosette API options (optional, should be a hash)
  attr_accessor :rosette_options
  # Parameters map sent to the API (optional, should be a hash)
  attr_accessor :parameters
  # Name to be compared to name2
  attr_accessor :name1
  # Name to be compared to name1
  attr_accessor :name2

  def initialize(name1, name2, match_parameters = nil) # :notnew:
    @name1 = name1
    @name2 = name2
    @genre = nil
    @parameters = nil
    @rosette_options = nil

    handle_match_parameters(match_parameters) if match_parameters
  end

  # Validates the parameters by checking if name1 and name2 are instances of
  # a String or NameParameter.
  def validate_params
    n1_msg = 'name1 option can only be an instance of a String or NameParameter'
    raise BadRequestError.new(n1_msg) if [String, NameParameter].none? { |clazz| @name1.is_a? clazz }

    n2_msg = 'name2 option can only be an instance of a String or NameParameter'
    raise BadRequestError.new(n2_msg) if [String, NameParameter].none? { |clazz| @name2.is_a? clazz }

    opt_msg = 'parameters can only be an instance of a Hash'
    raise BadRequestError.new(opt_msg) if @parameters && !(@parameters.is_a? Hash)

    rosette_opt_msg = 'rosette_options can only be an instance of a Hash'
    raise BadRequestError.new(rosette_opt_msg) if @rosette_options && !(@rosette_options.is_a? Hash)
  end

  # Converts this class to Hash with its keys in lower CamelCase.
  #
  # Returns the new Hash.
  def load_params
    validate_params
    to_hash
      .compact
      .transform_keys { |key| key.to_s.split('_').map(&:capitalize).join.sub!(/\D/, &:downcase) }
  end

  # Converts this class to Hash.
  #
  # Returns the new Hash.
  def to_hash
    if @parameters
      {
        name1: @name1.is_a?(NameParameter) ? @name1.load_param : @name1,
        name2: @name2.is_a?(NameParameter) ? @name2.load_param : @name2,
        parameters: @parameters
      }
    else
      {
        genre: @genre,
        name1: @name1.is_a?(NameParameter) ? @name1.load_param : @name1,
        name2: @name2.is_a?(NameParameter) ? @name2.load_param : @name2,
        options: @rosette_options
      }
    end
  end

  private

  # Processes the 3rd argument to determine if it is using the legacy 'options' signature
  # or the new 'match_parameters' signature, and assigns instance variables accordingly.
  def handle_match_parameters(match_parameters)
    if legacy_options?(match_parameters)
      warn 'DEPRECATION WARNING: Passing `options` dynamically via NameSimilarityParameters.new is deprecated. Please pass `parameters` instead.'
      @genre = match_parameters[:genre] || match_parameters['genre']
      @rosette_options = match_parameters[:rosette_options] || match_parameters['rosette_options']
    else
      @parameters = match_parameters
    end
  end

  def legacy_options?(params)
    return false unless params.is_a?(Hash)

    params.key?(:genre) || params.key?('genre') || params.key?(:rosette_options) || params.key?('rosette_options')
  end
end
