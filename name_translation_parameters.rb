require_relative 'rosette_api_error'

class NameTranslationParameters
  attr_accessor :entity_type, :name, :source_language_of_origin, :source_language_of_use, :source_script,
                :target_language, :target_scheme, :target_script

  def initialize
    @entity_type = nil
    @name = nil
    @source_language_of_origin = nil
    @source_language_of_use = nil
    @source_script = nil
    @target_language = nil
    @target_scheme = nil
    @target_script = nil
  end

  def validate_params
    if @name.nil?
      raise RosetteAPIError.new('badRequestFormat', 'The format of the request is invalid: invalid options: name: may not be null')
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