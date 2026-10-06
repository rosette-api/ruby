# frozen_string_literal: true

require_relative 'bad_request_error'

# This class encapsulates parameters that are needed for record-similarity in
# Analytics API.
class RecordSimilarityParameters
  # Records to be compared (required)
  attr_accessor :records

  # Field names/definitions used for similarity scoring (required)
  attr_accessor :fields

  # Optional properties map sent to the API (optional, should be a hash)
  attr_accessor :properties

  # Comparison method (one_to_one, one_to_n, n_to_m) (optional)
  attr_accessor :comparison_method

  VALID_COMPARISON_METHODS = %w[one_to_one one_to_n n_to_m].freeze

  def initialize(fields, records, properties = nil, comparison_method: nil, **property_keywords) # :notnew:
    properties_msg = 'properties must be passed either positionally or as keywords, not both'
    raise ArgumentError.new(properties_msg) unless properties.nil? || property_keywords.empty?

    @fields = fields
    @records = records
    # Preserve legacy calls such as new(fields, records, threshold: 0.7).
    @properties = property_keywords.empty? ? properties : property_keywords
    @comparison_method = comparison_method

    validate_comparison_method
  end

  def validate_comparison_method
    return if @comparison_method.nil?

    normalized = @comparison_method.to_s.downcase
    return if VALID_COMPARISON_METHODS.include?(normalized)

    raise ArgumentError.new("comparison_method must be one of: #{VALID_COMPARISON_METHODS.join(', ')}")
  end

  # Validates the parameters by checking if required fields are present and
  # optional properties is a Hash and comparison method is valid if provided.
  def validate_params
    f_msg = 'fields option is required'
    raise BadRequestError.new(f_msg) if @fields.nil?

    f_type_msg = 'fields can only be an instance of a Hash'
    raise BadRequestError.new(f_type_msg) unless @fields.is_a? Hash

    f_empty_msg = 'fields must not be empty'
    raise BadRequestError.new(f_empty_msg) if @fields.empty?

    r_msg = 'records option is required'
    raise BadRequestError.new(r_msg) if @records.nil?

    r_type_msg = 'records can only be an instance of a Hash'
    raise BadRequestError.new(r_type_msg) unless @records.is_a? Hash

    r_empty_msg = 'records must not be empty'
    raise BadRequestError.new(r_empty_msg) if @records.empty?

    p_msg = 'properties can only be an instance of a Hash'
    raise BadRequestError.new(p_msg) if @properties && !(@properties.is_a? Hash)

    validate_comparison_method
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
    {
      fields: @fields,
      records: @records,
      properties: @properties,
      comparison_method: @comparison_method&.to_s&.downcase
    }
  end
end
