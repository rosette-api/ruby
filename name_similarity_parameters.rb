require_relative 'rosette_api_error'
require_relative 'name_parameter'

class NameSimilarityParameters
  attr_accessor :name1, :name2

  def initialize(name1, name2)
    @name1 = name1
    @name2 = name2
  end

  def validate_params
    if [String, NameParameter].count { |clazz| @name1.instance_of? clazz } == 0
      raise RosetteAPIError.new('badRequest', 'name1 option can only be an instance of a String or NameParameter')
    elsif [String, Hash].count { |clazz| @name2.instance_of? clazz } == 0
      raise RosetteAPIError.new('badRequest', 'name2 option can only be an instance of a String or NameParameter')
    end
  end

  def load_params
    validate_params
    self.to_hash.select { |k, v| !v.nil? }.map { |k, v| [k.to_s.split('_').collect(&:capitalize).join.sub!(/\D/, &:downcase), v] }.to_h
  end

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var).instance_of?(NameParameter) ? instance_variable_get(var).load_param : instance_variable_get(var) }
    hash
  end
end