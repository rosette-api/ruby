require_relative 'bad_request_error'
require_relative 'name_parameter'

class NameSimilarityParameters
  attr_accessor :name1, :name2

  def initialize(name1, name2)
    @name1 = name1
    @name2 = name2
  end

  def validate_params
    if [String, NameParameter].none? { |clazz| @name1.is_a? clazz }
      raise BadRequestError.new('name1 option can only be an instance of a String or NameParameter')
    elsif [String, NameParameter].none? { |clazz| @name2.is_a? clazz }
      raise BadRequestError.new('name2 option can only be an instance of a String or NameParameter')
    end
  end

  def load_params
    self.validate_params
    self.to_hash.select { |key, value| !value.nil? }
                .map { |key, value| [key.to_s.split('_').map(&:capitalize).join.sub!(/\D/, &:downcase), value] }
                .to_h
  end

  def to_hash
    {
      'name1' => @name1.is_a?(NameParameter) ? @name1.load_param : @name1,
      'name2' => @name2.is_a?(NameParameter) ? @name2.load_param : @name2
    }
  end
end
