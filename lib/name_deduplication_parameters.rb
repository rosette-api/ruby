# frozen_string_literal: true
require_relative 'bad_request_error'
require_relative 'name_parameter'

# This class encapsulates parameters that are needed for name-deduplication in
# Rosette API.
class NameDeduplicationParameters
  # Rosette API options (optional, should be a hash)
  attr_accessor :rosette_options
  # List of Name objects to be de-duplicated
  attr_accessor :names
  # Threshold for determining cluster size
  attr_accessor :threshold

  def initialize(names, threshold, options = {}) #:notnew:
    options = {
      rosette_options: nil
    }.update options
    @names = names
    @threshold = threshold
    @rosette_options = options[:rosette_options]
  end

  # Validates the parameters by checking if name1 and name2 are instances of
  # a String or NameParameter.
  def validate_params
    raise BadRequestError.new('names must be an array of name_parameter'
      ) unless @names.instance_of? Array
    if @threshold
      raise BadRequestError.new('threshold must be a float'
        ) unless @threshold.is_a?(Float)
      raise BadRequestError.new('threshold must be in the range of 0 to 1'
        ) if @threshold.negative? || @threshold > 1
    end
    if @rosette_options
      raise BadRequestError.new(
        'rosette_options can only be an instance of a Hash'
          ) unless @rosette_options.is_a? Hash
    end
  end

  # Converts this class to Hash with its keys in lower CamelCase.
  #
  # Returns the new Hash.
  def load_params
    validate_params
    to_hash.select { |_key, value| value }
           .map { |key, value| [key.to_s.split('_')
                                   .map(&:capitalize)
                                   .join.sub!(/\D/, &:downcase), value] }
           .to_h
  end

  # Converts this class to Hash.
  #
  # Returns the new Hash.
  def to_hash
    {
      names: @names.map(&:load_param),
      threshold: @threshold,
      options: @rosette_options
    }
  end
end
