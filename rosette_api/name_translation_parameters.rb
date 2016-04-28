require_relative 'rosette_api_error'

# This class encapsulates parameters that are needed for name-translation in
# Rosette API.
class NameTranslationParameters
  # name's entity type (PERSON, LOCATION, ORGANIZATION)
  attr_accessor :entity_type
  # name to translate
  attr_accessor :name
  # ISO 693-3 code for name's language of use (optional)
  attr_accessor :source_language_of_origin
  # ISO 15924 code for name's script (optional)
  attr_accessor :source_language_of_use
  # ISO 15924 code for name's script (optional)
  attr_accessor :source_script
  # ISO 639-3 code for the translation language
  attr_accessor :target_language
  # transliteration scheme for the translation (optional)
  attr_accessor :target_scheme
  # ISO 15924 code for name's script (optional)
  attr_accessor :target_script

  def initialize(name, options = {}) #:notnew:
    options = {
      entity_type: nil,
      source_language_of_origin: nil,
      source_language_of_use: nil,
      source_script: nil,
      target_language: nil,
      target_scheme: nil,
      target_script: nil
    }.update options
    @name = name # name to be translated
    @entity_type = options[:entity_type]
    @source_language_of_origin = options[:source_language_of_origin]
    @source_language_of_use = options[:source_language_of_use]
    @source_script = options[:source_script]
    @target_language = options[:target_language]
    @target_scheme = options[:target_scheme]
    @target_script = options[:target_script]
  end

  # Converts this class to Hash with its keys in lower CamelCase
  #
  # Returns the new Hash
  def load_params
    self.to_hash.select { |key, value| !value.nil? }
                .map { |key, value| [key.to_s.split('_').map(&:capitalize).join.sub!(/\D/, &:downcase), value] }
                .to_h
  end

  # Converts this class to Hash.
  #
  # Returns the new Hash
  def to_hash
    {
      entity_type: @entity_type,
      name: @name,
      source_language_of_origin: @source_language_of_origin,
      source_language_of_use: @source_language_of_use,
      source_script: @source_script,
      target_language: @target_language,
      target_scheme: @target_scheme,
      target_script: @target_script
    }
  end
end
