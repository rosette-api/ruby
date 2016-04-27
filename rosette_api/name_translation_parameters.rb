require_relative 'rosette_api_error'

# This class encapsulates parameters that are needed for name-translation in
# Rosette API.
class NameTranslationParameters
  attr_accessor :entity_type,
                :name,
                :source_language_of_origin,
                :source_language_of_use,
                :source_script,
                :target_language,
                :target_scheme,
                :target_script

  def initialize(name, options = {})
    options = {
      entity_type: nil,
      source_language_of_origin: nil,
      source_language_of_use: nil,
      source_script: nil,
      target_language: nil,
      target_scheme: nil,
      target_script: nil
    }.update options
    @name = name
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
