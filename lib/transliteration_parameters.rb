require_relative 'bad_request_error'

# This class encapsulates parameters that are needed for transliteration in
# Rosette API.
class TransliterationParameters
  # Rosette API options (optional, should be a hash)
  attr_accessor :rosette_options
  # Content to be transliterated
  attr_accessor :content
  # Target Language
  attr_accessor :target_language
  # Target Script
  attr_accessor :target_script
  # Source Language
  attr_accessor :source_language
  # Source Script
  attr_accessor :source_script

  def initialize(content, target_language, target_script, source_language, source_script, options = {}) #:notnew:
    options = {
      rosette_options: nil
    }.update options
    @content = content
    @target_language = target_language
    @target_script = target_script
    @source_language = source_language
    @source_script = source_script
    @rosette_options = options[:rosette_options]
  end

  # Validates the parameters by checking if name1 and name2 are instances of
  # a String or NameParameter.
  def validate_params
    raise BadRequestError.new('content must be provided') unless @content
    raise BadRequestError.new('target_language must be provided') unless @target_language
    raise BadRequestError.new('target_script must be provided') unless @target_script
    raise BadRequestError.new('source_language must be provided') unless @source_language
    raise BadRequestError.new('source_script must be provided') unless @source_script
    if @rosette_options
      raise BadRequestError.new('rosette_options can only be an instance of a Hash') unless @rosette_options.is_a? Hash
    end
  end

  # Converts this class to Hash with its keys in lower CamelCase.
  #
  # Returns the new Hash.
  def load_params
    validate_params
    to_hash.select { |_key, value| value }
           .map { |key, value| [key.to_s.split('_').map(&:capitalize).join.sub!(/\D/, &:downcase), value] }
           .to_h
  end

  # Converts this class to Hash.
  #
  # Returns the new Hash.
  def to_hash
    {
      content: @content,
      target_language: @target_language,
      target_script: @target_script,
      source_language: @source_language,
      source_script: @source_script,
      options: @rosette_options
    }
  end
end
