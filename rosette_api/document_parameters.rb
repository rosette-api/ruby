require_relative 'bad_request_format_error'

# This class encapsulates parameters that will be used by most of the endpoints
# with exclusion of name-similarity and name-translation.
class DocumentParameters
  attr_accessor :content, :content_uri, :file_path, :language

  def initialize(options = {})
    options = {
      content: nil,
      content_uri: nil,
      file_path: nil,
      language: nil
    }.update options
    @content = options[:content]
    @content_uri = options[:content_uri]
    @file_path = options[:file_path]
    @language = options[:language]
  end

  # Validates the parameters by checking if there are multiple content sources
  # set or no content provided at all.
  def validate_params
    if [@content, @content_uri, @file_path].compact.length > 1
      raise BadRequestFormatError.new 'The format of the request is invalid: multiple content sources;' \
                                      ' must be one of an attachment, an inline "content" field, or an external "contentUri"'
    elsif [@content, @content_uri, @file_path].all?(&:nil?)
      raise BadRequestFormatError.new 'The format of the request is invalid: no content provided; must' \
                                      ' be one of an attachment, an inline "content" field, or an external "contentUri"'
    end
  end

  # Converts this class to Hash with its keys in lower CamelCase
  #
  # Returns the new Hash
  def load_params
    self.validate_params
    self.to_hash.select { |key, value| !value.nil? }
                .map { |key, value| [key.to_s.split('_').map(&:capitalize).join.sub!(/\D/, &:downcase), value] }
                .to_h
  end

  # Converts this class to Hash.
  #
  # Returns the new Hash
  def to_hash
    {
      content: @content,
      content_uri: @content_uri,
      file_path: @file_path,
      language: @language
    }
  end
end
