class NameParameter
  attr_accessor :text, :entity_type, :language, :script

  def initialize(text)
    @text = text
    @entity_type = nil
    @language = nil
    @script = nil
  end

  def load_param
    self.to_hash.select { |k, v| !v.nil? }.map { |k, v| [k.to_s.split('_').collect(&:capitalize).join.sub!(/\D/, &:downcase), v] }.to_h
  end

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
    hash
  end
end