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

  def initialize(fields, records, properties = nil) # :notnew:
    @fields = fields
    @records = records
    @properties = properties
  end

  # Validates the parameters by checking if required fields are present and
  # optional properties is a Hash if provided.
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
      properties: @properties
    }
  end
end
