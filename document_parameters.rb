require_relative 'rosette_api_error'

class DocumentParameters
  attr_accessor :content, :content_uri, :file_path, :language

  def initialize
    @content = nil
    @content_uri = nil
    @file_path = nil
    @language = nil
  end

  def validate_params
    if [@content, @content_uri, @file_path].count { |attr| !attr.nil? } > 1
      raise RosetteAPIError.new('badRequestFormat', 'The format of the request is invalid: multiple content sources;' \
          ' must be one of an attachment, an inline "content" field, or an external "contentUri"')
    elsif [@content, @content_uri, @file_path].count { |attr| attr.nil? } == 3
      raise RosetteAPIError.new('badRequestFormat', 'The format of the request is invalid: no content provided; must' \
          ' be one of an attachment, an inline "content" field, or an external "contentUri"')
    end
  end

  def load_params
    validate_params
    self.to_hash.select { |k, v| !v.nil? }.map { |k, v| [k.to_s.split('_').collect(&:capitalize).join.sub!(/\D/, &:downcase), v] }.to_h
  end

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
    hash
  end
end