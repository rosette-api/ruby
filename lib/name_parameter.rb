# frozen_string_literal: true
# This class represents an entity name in Rosette API.
class NameParameter
  # Name's entity type (PERSON, LOCATION, ORGANIZATION) (optional)
  attr_accessor :entity_type
  # ISO 639-3 code of the name's language (optional)
  attr_accessor :language
  # ISO 15924 code of the name's script (optional)
  attr_accessor :script
  # Name to be analyzed
  attr_accessor :text

  def initialize(text, options = {}) #:notnew:
    options = {
      entity_type: nil,
      language: nil,
      script: nil
    }.update options
    @text = text
    @entity_type = options[:entity_type]
    @language = options[:language]
    @script = options[:script]
  end

  # Converts this class to Hash with its keys in lower CamelCase.
  #
  # Returns the new Hash.
  def load_param
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
      entity_type: @entity_type,
      language: @language,
      script: @script,
      text: @text
    }
  end
end
