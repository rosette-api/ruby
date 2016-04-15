require_relative 'rosette_api_error'

class Parameters

  attr_accessor :content, :content_uri, :language, :entity_type, :name, :source_language_of_origin,
                :source_language_of_use, :source_script, :target_language, :target_scheme, :target_script, :name1,
                :name2, :file_path

  def initialize
    #general
    @content = nil
    @content_uri = nil
    @file_path = nil
    @language = nil
    #name-translation
    @entity_type = nil
    @name = nil
    @source_language_of_origin = nil
    @source_language_of_use = nil
    @source_script = nil
    @target_language = nil
    @target_scheme = nil
    @target_script = nil
    #name-similarity
    @name1 = nil
    @name2 = nil
  end

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
    hash
  end

  def validate_params
    if [@content, @content_uri, @file_path].count { |attr| !attr.nil? } > 1
      raise RosetteAPIError.new(400, 'The format of the request is invalid: multiple content sources;' \
          ' must be one of an attachment, an inline "content" field, or an external "contentUri"')
    elsif [@content, @content_uri, @file_path].count { |attr| attr.nil? } == 3 && [@name, @name1, @name2].count { |attr| attr.nil? } > 0
      raise RosetteAPIError.new(400, 'The format of the request is invalid: no content provided; must' \
          ' be one of an attachment, an inline "content" field, or an external "contentUri"')
    else
      load_params
    end
  end

  def validate_name_similarity_params
    if @name1.nil?
      raise RosetteAPIError.new(400, 'The format of the request is invalid: invalid options: name1 may not be null')
    elsif name2.nil?
      raise RosetteAPIError.new(400, 'The format of the request is invalid: invalid options: name2 may not be null')
    else
      load_params
    end
  end

  def validate_name_translation_params
    if @name.nil?
      raise RosetteAPIError.new(400, 'The format of the request is invalid: invalid options: name: may not be null')
    else
      load_params
    end
  end

  def load_params
    self.to_hash.select { |k, v| !v.nil? }.map { |k, v| [k.to_s.split('_').collect(&:capitalize).join.sub!(/\D/, &:downcase), v] }.to_h
  end
end