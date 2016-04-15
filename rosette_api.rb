require_relative 'request_builder'

class RosetteAPI
  BINDING_VERSION = '1.0.2'
  LANGUAGE_ENDPOINT = '/language'
  MORPHOLOGY_ENDPOINT = '/morphology'
  ENTITIES_ENDPOINT = '/entities'
  ENTITIES_LINKED_ENDPOINT= '/entities/linked'
  CATEGORIES_ENDPOINT = '/categories'
  RELATIONSHIPS_ENDPOINT = '/relationships'
  SENTIMENT_ENDPOINT = '/sentiment'
  NAME_TRANSLATION_ENDPOINT = '/name-translation'
  NAME_SIMILARITY_ENDPOINT = '/name-similarity'
  TOKENS_ENDPOINT = '/tokens'
  SENTENCES_ENDPOINT = '/sentences'
  INFO = '/info'
  VERSION_CHECK = '/info?clientVersion=' + BINDING_VERSION
  PING = '/ping'

  attr_accessor :user_key, :alternate_url

  def initialize(user_key, alternate_url='https://api.rosette.com/rest/v1')
    @user_key = user_key
    @alternate_url = alternate_url
    if @alternate_url.to_s.end_with?('/')
      @alternate_url = alternate_url.to_s.slice(0..-2)
    end
    check_version_compatibility
  end

  def check_version_compatibility
    response = RequestBuilder.new(@user_key, @alternate_url + VERSION_CHECK).send_post_request
    unless response['versionChecked']
      puts JSON.pretty_generate(response)
      exit
    end
  end

  def get_language(params)
    params = params.validate_params
    RequestBuilder.new(@user_key, @alternate_url + LANGUAGE_ENDPOINT, params).send_post_request
  end

  def get_morphology_complete(params)
    params = params.validate_params
    RequestBuilder.new(@user_key, @alternate_url + MORPHOLOGY_ENDPOINT + '/complete', params).send_post_request
  end

  def get_compound_components(params)
    params = params.validate_params
    RequestBuilder.new(@user_key, @alternate_url +MORPHOLOGY_ENDPOINT + '/compound-components', params)
        .send_post_request
  end

  def get_han_readings(params)
    params = params.validate_params
    RequestBuilder.new(@user_key, @alternate_url + MORPHOLOGY_ENDPOINT + '/han-readings', params).send_post_request
  end

  def get_lemmas(params)
    params = params.validate_params
    RequestBuilder.new(@user_key, @alternate_url + MORPHOLOGY_ENDPOINT + '/lemmas', params).send_post_request
  end

  def get_parts_of_speech(params)
    params = params.validate_params
    RequestBuilder.new(@user_key, @alternate_url + MORPHOLOGY_ENDPOINT + '/parts-of-speech', params).send_post_request
  end

  def get_entities(params)
    params = params.validate_params
    RequestBuilder.new(@user_key, @alternate_url + ENTITIES_ENDPOINT, params).send_post_request
  end

  def get_entities_linked(params)
    params = params.validate_params
    RequestBuilder.new(@user_key, @alternate_url + ENTITIES_LINKED_ENDPOINT, params).send_post_request
  end

  def get_categories(params)
    params = params.validate_params
    RequestBuilder.new(@user_key, @alternate_url + CATEGORIES_ENDPOINT, params).send_post_request
  end

  def get_relationships(params)
    params = params.validate_params
    RequestBuilder.new(@user_key, @alternate_url + RELATIONSHIPS_ENDPOINT, params).send_post_request
  end

  def get_sentiment(params)
    params = params.validate_params
    RequestBuilder.new(@user_key, @alternate_url + SENTIMENT_ENDPOINT, params).send_post_request
  end

  def name_translation(params)
    params = params.validate_name_translation_params
    RequestBuilder.new(@user_key, @alternate_url + NAME_TRANSLATION_ENDPOINT, params).send_post_request
  end

  def name_similarity(params)
    params = params.validate_name_similarity_params
    RequestBuilder.new(@user_key, @alternate_url + NAME_SIMILARITY_ENDPOINT, params).send_post_request
  end

  def get_tokens(params)
    params = params.validate_params
    RequestBuilder.new(@user_key, @alternate_url + TOKENS_ENDPOINT, params).send_post_request
  end

  def get_sentences(params)
    params = params.validate_params
    RequestBuilder.new(@user_key, @alternate_url + SENTENCES_ENDPOINT, params).send_post_request
  end

  def info
    RequestBuilder.new(@user_key, @alternate_url + INFO).send_get_request
  end

  def ping
    RequestBuilder.new(@user_key, @alternate_url + PING).send_get_request
  end
end