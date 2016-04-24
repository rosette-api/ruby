require_relative 'request_builder'
require_relative 'document_parameters'
require_relative 'name_translation_parameters'
require_relative 'name_similarity_parameters'
require_relative 'rosette_api_error'
require_relative 'bad_request_error'
require_relative 'bad_request_format_error'

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

  def initialize(user_key, alternate_url = 'https://api.rosette.com/rest/v1')
    @user_key = user_key
    @alternate_url = alternate_url

    if @alternate_url.to_s.end_with?('/')
      @alternate_url = alternate_url.to_s.slice(0..-2)
    end

    self.check_version_compatibility
  end

  def check_version_compatibility
    response = RequestBuilder.new(@user_key, @alternate_url + VERSION_CHECK)
                             .send_post_request

    unless response['versionChecked']
      puts JSON.pretty_generate(response)

      exit
    end
  end

  def get_language(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + LANGUAGE_ENDPOINT, params)
                  .send_post_request
  end

  def get_morphology_complete(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + MORPHOLOGY_ENDPOINT + '/complete', params)
                  .send_post_request
  end

  def get_compound_components(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url +MORPHOLOGY_ENDPOINT + '/compound-components', params)
                  .send_post_request
  end

  def get_han_readings(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + MORPHOLOGY_ENDPOINT + '/han-readings', params)
                  .send_post_request
  end

  def get_lemmas(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + MORPHOLOGY_ENDPOINT + '/lemmas', params)
                  .send_post_request
  end

  def get_parts_of_speech(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + MORPHOLOGY_ENDPOINT + '/parts-of-speech', params)
                  .send_post_request
  end

  def get_entities(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + ENTITIES_ENDPOINT, params)
                  .send_post_request
  end

  def get_entities_linked(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + ENTITIES_LINKED_ENDPOINT, params)
                  .send_post_request
  end

  def get_categories(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + CATEGORIES_ENDPOINT, params)
                  .send_post_request
  end

  def get_relationships(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + RELATIONSHIPS_ENDPOINT, params)
                  .send_post_request
  end

  def get_sentiment(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + SENTIMENT_ENDPOINT, params)
                  .send_post_request
  end

  def name_translation(params)
    check_params params, 'Expects a NameTranslationParameters type as an argument', NameTranslationParameters

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + NAME_TRANSLATION_ENDPOINT, params)
                  .send_post_request
  end

  def name_similarity(params)
    check_params params, 'Expects a NameSimilarityParameters type as an argument', NameSimilarityParameters

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + NAME_SIMILARITY_ENDPOINT, params)
                  .send_post_request
  end

  def get_tokens(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + TOKENS_ENDPOINT, params)
                  .send_post_request
  end

  def get_sentences(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + SENTENCES_ENDPOINT, params)
                  .send_post_request
  end

  def info
    RequestBuilder.new(@user_key, @alternate_url + INFO)
                  .send_get_request
  end

  def ping
    RequestBuilder.new(@user_key, @alternate_url + PING)
                  .send_get_request
  end

  private

    def check_params(params, message = 'Expects a DocumentParameters type as an argument', type = DocumentParameters)
      raise BadRequest.new message unless params.is_a? type
    end
end
