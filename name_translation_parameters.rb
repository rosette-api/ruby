require_relative 'rosette_api_error'

class NameTranslationParameters
  attr_accessor :name, :entity_type, :source_language_of_origin, :source_language_of_use, :source_script,
                :target_language, :target_scheme, :target_script

  def initialize(name, entity_type=nil, source_language_of_origin=nil, source_language_of_use=nil, source_script=nil,
                 target_language=nil, target_scheme=nil, target_script=nil)
    @name = name
    @entity_type = entity_type
    @source_language_of_origin = source_language_of_origin
    @source_language_of_use = source_language_of_use
    @source_script = source_script
    @target_language = target_language
    @target_scheme = target_scheme
    @target_script = target_script
  end

  def load_params
    self.to_hash.select { |k, v| !v.nil? }.map { |k, v| [k.to_s.split('_').collect(&:capitalize).join.sub!(/\D/, &:downcase), v] }.to_h
  end

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
    hash
  end
end