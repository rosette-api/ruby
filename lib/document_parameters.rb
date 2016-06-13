require_relative 'bad_request_format_error'

# This class encapsulates parameters that will be used by most of the endpoints
# with exclusion of name-similarity and name-translation.
class DocumentParameters
  # Content to be analyzed (required if no content_uri and file_path)
  attr_accessor :content
  # URL to retrieve content from and analyze (required if no content and file_path)
  attr_accessor :content_uri
  # File path of the file to be analyzed (required if no content and content_uri)
  attr_accessor :file_path
  # genre to categorize the input data
  attr_accessor :genre
  # ISO 639-3 language code of the provided content (optional)
  attr_accessor :language
  # Rosette API options (optional, should be a hash)
  attr_accessor :rosette_options
  # custom Rosette API headers
  attr_accessor :custom_headers

  def initialize(options = {}) #:notnew:
    options = {
      content: nil,
      content_uri: nil,
      file_path: nil,
      genre: nil,
      language: nil,
      rosette_options: nil,
      custom_headers: nil
    }.update options
    @content = options[:content]
    @content_uri = options[:content_uri]
    @file_path = options[:file_path]
    @genre = options[:genre]
    @language = options[:language]
    @rosette_options = options[:rosette_options]
    @custom_headers = options[:custom_headers]
  end

  # Validates the parameters by checking if there are multiple content sources
  # set or no content provided at all.
  def validate_params
    if [@content, @content_uri, @file_path].compact.length > 1
      raise BadRequestFormatError.new 'The format of the request is invalid: multiple content sources;' \
                                      ' must be one of an attachment, an inline "content" field, or an external' \
                                      '"contentUri"'
    elsif [@content, @content_uri, @file_path].all?(&:nil?)
      raise BadRequestFormatError.new 'The format of the request is invalid: no content provided; must' \
                                      ' be one of an attachment, an inline "content" field, or an external "contentUri"'
    elsif !@rosette_options.nil?
      raise BadRequestError.new('rosette_options can only be an instance of a Hash') unless @rosette_options.is_a? Hash
    end
  end

  # Converts this class to Hash with its keys in lower CamelCase.
  #
  # Returns the new Hash.
  def load_params
    self.validate_params
    self.to_hash.select { |_key, value| !value.nil? }
        .map { |key, value| [key.to_s.split('_').map(&:capitalize).join.sub!(/\D/, &:downcase), value] }
        .to_h
  end

  # Converts this class to Hash.
  #
  # Returns the new Hash.
  def to_hash
    {
      content: @content,
      content_uri: @content_uri,
      file_path: @file_path,
      genre: @genre,
      language: @language,
      options: @rosette_options,
      custom_headers: @custom_headers
    }
  end
end
