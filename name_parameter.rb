class NameParameter
  attr_accessor :entity_type,
                :language,
                :script,
                :text

  def initialize(text, option = {})
    options = {
      'entity_type' => nil,
      'language' => nil,
      'script' => nil
    }.update options
    @text = text
    @entity_type = options['entity_type']
    @language = options['language']
    @script = options['script']
  end

  def load_param
    self.to_hash.select { |key, value| !value.nil? }
                .map { |key, value| [key.to_s.split('_').map(&:capitalize).join.sub!(/\D/, &:downcase), value] }
                .to_h
  end

  def to_hash
    {
      'entity_type' => @entity_type,
      'language' => @language,
      'script' => @script,
      'text' => @text
    }
  end
end
