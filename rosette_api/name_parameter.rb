# This class represents an entity name in Rosette API.
class NameParameter
  attr_accessor :entity_type,
                :language,
                :script,
                :text

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
  # Returns the new Hash
  def load_param
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
      language: @language,
      script: @script,
      text: @text
    }
  end
end
