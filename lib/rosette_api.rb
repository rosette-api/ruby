require_relative 'request_builder'
require_relative 'document_parameters'
require_relative 'name_translation_parameters'
require_relative 'name_similarity_parameters'
require_relative 'rosette_api_error'
require_relative 'bad_request_error'
require_relative 'bad_request_format_error'

# This class allows you to access all Rosette API endpoints.
class RosetteAPI
  # Version of Ruby binding
  BINDING_VERSION = '1.1.1'
  # Rosette API language endpoint
  LANGUAGE_ENDPOINT = '/language'
  # Rosette API morphology endpoint
  MORPHOLOGY_ENDPOINT = '/morphology'
  # Rosette API entities endpoint
  ENTITIES_ENDPOINT = '/entities'
  # Rosette API categories endpoint
  CATEGORIES_ENDPOINT = '/categories'
  # Rosette API relationships endpoint
  RELATIONSHIPS_ENDPOINT = '/relationships'
  # Rosette API sentiment endpoint
  SENTIMENT_ENDPOINT = '/sentiment'
  # Rosette API name-translation endpoint
  NAME_TRANSLATION_ENDPOINT = '/name-translation'
  # Rosette API name-similarity endpoint
  NAME_SIMILARITY_ENDPOINT = '/name-similarity'
  # Rosette API tokens endpoint
  TOKENS_ENDPOINT = '/tokens'
  # Rosette API sentences endpoint
  SENTENCES_ENDPOINT = '/sentences'
  # Rosette API info endpoint
  INFO = '/info'
  # Rosette API ping endpoint
  PING = '/ping'

  # Rosette API key
  attr_accessor :user_key
  # Alternate Rosette API URL
  attr_accessor :alternate_url
  # custom Rosette API headers
  attr_accessor :custom_headers

  def initialize(user_key, alternate_url = 'https://api.rosette.com/rest/v1') #:notnew:
    @user_key = user_key
    @alternate_url = alternate_url

    if @alternate_url.to_s.end_with?('/')
      @alternate_url = alternate_url.to_s.slice(0..-2)
    end
  end

  # Identifies in which language(s) the input is written.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in RequestBuilder.
  #
  # Returns list of candidate languages in order of descending confidence.
  def get_language(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + LANGUAGE_ENDPOINT, params, BINDING_VERSION)
                  .send_post_request
  end

  # Extracts parts-of-speech, lemmas (dictionary form), compound components,
  # and Han-readings for each token in the input.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in RequestBuilder.
  #
  # Returns the lemmas, compound components, Han-readings, and parts-of-speech
  # tags of the input for supported languages.
  def get_morphology_complete(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + MORPHOLOGY_ENDPOINT + '/complete', params, BINDING_VERSION)
                  .send_post_request
  end

  # Extracts compound-components from the input.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in RequestBuilder.
  #
  # Returns list of components for each compound word of the input for supported
  # languages.
  def get_compound_components(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + MORPHOLOGY_ENDPOINT + '/compound-components', params, BINDING_VERSION)
                  .send_post_request
  end

  # Extracts Han-readings from the input.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in RequestBuilder.
  #
  # Returns list of Han-readings which provide pronunciation information for
  # Han script, in both Chinese and Japanese input text.
  def get_han_readings(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + MORPHOLOGY_ENDPOINT + '/han-readings', params, BINDING_VERSION)
                  .send_post_request
  end

  # Extracts lemmas from the input.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in RequestBuilder.
  #
  # Returns list of lemmas for each token of the input for supported languages.
  def get_lemmas(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + MORPHOLOGY_ENDPOINT + '/lemmas', params, BINDING_VERSION)
                  .send_post_request
  end

  # Extracts parts-of-speech from the input.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in RequestBuilder.
  #
  # Returns list of part-of-speech (POS) tags for each of the words of the
  # input, depending on the context of how it is used.
  def get_parts_of_speech(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + MORPHOLOGY_ENDPOINT + '/parts-of-speech', params, BINDING_VERSION)
                  .send_post_request
  end

  # Extracts entities from the input.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in RequestBuilder.
  #
  # Returns each entity extracted from the input.
  def get_entities(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + ENTITIES_ENDPOINT, params, BINDING_VERSION)
                  .send_post_request
  end

  # Extracts Tier 1 contextual categories from the input.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in RequestBuilder.
  #
  # Returns the contextual categories identified in the input.
  def get_categories(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + CATEGORIES_ENDPOINT, params, BINDING_VERSION)
                  .send_post_request
  end

  # Extracts relationships from the input.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in RequestBuilder.
  #
  # Returns each relationship extracted from the input.
  def get_relationships(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + RELATIONSHIPS_ENDPOINT, params, BINDING_VERSION)
                  .send_post_request
  end

  # Analyzes the positive and negative sentiment expressed by the input.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in RequestBuilder.
  #
  # Returns sentiment analysis results.
  def get_sentiment(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + SENTIMENT_ENDPOINT, params, BINDING_VERSION)
                  .send_post_request
  end

  # Translates a given name to a supported specified language.
  #
  # ==== Attributes
  #
  # * +params+ - NameTranslationParameters helps to build the request body in RequestBuilder.
  #
  # Returns the translation of a name.
  def name_translation(params)
    check_params params, 'Expects a NameTranslationParameters type as an argument', NameTranslationParameters

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + NAME_TRANSLATION_ENDPOINT, params, BINDING_VERSION)
                  .send_post_request
  end

  # Compares two entity names (person, location, or organization) and returns a
  # match score from 0 to 1.
  #
  # ==== Attributes
  #
  # * +params+ - NameSimilarityParameters helps to build the request body in RequestBuilder.
  #
  # Returns the confidence score of matching 2 names.
  def name_similarity(params)
    check_params params, 'Expects a NameSimilarityParameters type as an argument', NameSimilarityParameters

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + NAME_SIMILARITY_ENDPOINT, params, BINDING_VERSION)
                  .send_post_request
  end

  # Divides the input into tokens.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in RequestBuilder.
  #
  # Returns list of tokens of the input.
  def get_tokens(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + TOKENS_ENDPOINT, params, BINDING_VERSION)
                  .send_post_request
  end

  # Divides the input into sentences.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in RequestBuilder.
  #
  # Returns list of linguistic sentences of the input.
  def get_sentences(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + SENTENCES_ENDPOINT, params, BINDING_VERSION)
                  .send_post_request
  end

  # Gets information about the Rosette API, returns name, build number
  # and build time.
  def info
    RequestBuilder.new(@user_key, @alternate_url + INFO, BINDING_VERSION)
                  .send_get_request
  end

  # Pings the Rosette API for a response indicting that the service is
  # available.
  def ping
    RequestBuilder.new(@user_key, @alternate_url + PING, BINDING_VERSION)
                  .send_get_request
  end

  private

    # Checks that the right parameter type is being passed in.
    def check_params(params, message = 'Expects a DocumentParameters type as an argument', type = DocumentParameters)
      raise BadRequestError.new message unless params.is_a? type
    end
end

