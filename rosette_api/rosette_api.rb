require_relative 'request_builder'
require_relative 'document_parameters'
require_relative 'name_translation_parameters'
require_relative 'name_similarity_parameters'
require_relative 'rosette_api_error'
require_relative 'bad_request_error'
require_relative 'bad_request_format_error'

# This class allows you to access all Rosette API endpoints.
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

  # Checks binding version compatibility against the Rosette API server.
  def check_version_compatibility
    response = RequestBuilder.new(@user_key, @alternate_url + VERSION_CHECK)
                             .send_post_request

    unless response['versionChecked']
      puts JSON.pretty_generate(response)

      exit
    end
  end

  # Identifies in which language(s) the input is written.
  #
  # params - DocumentParameters help build the request body in RequestBuilder
  #
  # Returns list of candidate languages in order of descending confidence.
  def get_language(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + LANGUAGE_ENDPOINT, params)
                  .send_post_request
  end

  # Extracts parts-of-speech, lemmas (dictionary form), compound components,
  # and Han-readings for each token in the input.
  #
  # params - DocumentParameters help build the request body in RequestBuilder
  #
  # Returns the lemmas, compound components, Han-readings, and parts-of-speech
  # tags of the input for supported languages.
  def get_morphology_complete(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + MORPHOLOGY_ENDPOINT + '/complete', params)
                  .send_post_request
  end

  # Extracts compound-components from the input.
  #
  # params - DocumentParameters help build the request body in RequestBuilder
  #
  # Returns list of components for each compound word of the input for supported
  # languages.
  def get_compound_components(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url +MORPHOLOGY_ENDPOINT + '/compound-components', params)
                  .send_post_request
  end

  # Extracts Han-readings from the input.
  #
  # params - DocumentParameters help build the request body in RequestBuilder
  #
  # Returns list of Han-readings which provide pronunciation information for
  # Han script, in both Chinese and Japanese input text.
  def get_han_readings(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + MORPHOLOGY_ENDPOINT + '/han-readings', params)
                  .send_post_request
  end

  # Extracts lemmas from the input.
  #
  # params - DocumentParameters help build the request body in RequestBuilder
  #
  # Returns list of lemmas for each token of the input for supported languages.
  def get_lemmas(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + MORPHOLOGY_ENDPOINT + '/lemmas', params)
                  .send_post_request
  end

  # Extracts parts-of-speech from the input.
  #
  # params - DocumentParameters help build the request body in RequestBuilder
  #
  # Returns list of part-of-speech (POS) tags for each of the words of the
  # input, depending on the context of how it is used.
  def get_parts_of_speech(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + MORPHOLOGY_ENDPOINT + '/parts-of-speech', params)
                  .send_post_request
  end

  # Extracts entities from the input.
  #
  # params - DocumentParameters help build the request body in RequestBuilder
  #
  # Returns each entity extracted from the input.
  def get_entities(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + ENTITIES_ENDPOINT, params)
                  .send_post_request
  end

  # Extracts entities from the input.
  #
  # params - DocumentParameters help build the request body in RequestBuilder
  #
  # Returns list of entities that have been linked to entities in the knowledge
  # base.
  def get_entities_linked(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + ENTITIES_LINKED_ENDPOINT, params)
                  .send_post_request
  end

  # Extracts Tier 1 contextual categories from the input.
  #
  # params - DocumentParameters help build the request body in RequestBuilder
  #
  # Returns the contextual categories identified in the input.
  def get_categories(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + CATEGORIES_ENDPOINT, params)
                  .send_post_request
  end

  # Extracts relationships from the input.
  #
  # params - DocumentParameters help build the request body in RequestBuilder
  #
  # Returns each relationship extracted from the input.
  def get_relationships(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + RELATIONSHIPS_ENDPOINT, params)
                  .send_post_request
  end

  # Analyzes the positive and negative sentiment expressed by the input.
  #
  # params - DocumentParameters help build the request body in RequestBuilder
  #
  # Returns sentiment analysis results.
  def get_sentiment(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + SENTIMENT_ENDPOINT, params)
                  .send_post_request
  end

  # Translates a given name to a supported specified language.
  #
  # params - NameTranslationParameters help build the request body in RequestBuilder
  #
  # Returns the translation of a name.
  def name_translation(params)
    check_params params, 'Expects a NameTranslationParameters type as an argument', NameTranslationParameters

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + NAME_TRANSLATION_ENDPOINT, params)
                  .send_post_request
  end

  # Compares two entity names (person, location, or organization) and returns a
  # match score from 0 to 1.
  #
  # params - NameSimilarityParameters help build the request body in RequestBuilder
  #
  # Returns the confidence score of matching 2 names.
  def name_similarity(params)
    check_params params, 'Expects a NameSimilarityParameters type as an argument', NameSimilarityParameters

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + NAME_SIMILARITY_ENDPOINT, params)
                  .send_post_request
  end

  # Divides the input into tokens.
  #
  # params - DocumentParameters help build the request body in RequestBuilder
  #
  # Returns list of tokens of the input.
  def get_tokens(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + TOKENS_ENDPOINT, params)
                  .send_post_request
  end

  # Divides the input into sentences.
  #
  # params - DocumentParameters help build the request body in RequestBuilder
  #
  # Returns list of linguistic sentences of the input.
  def get_sentences(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + SENTENCES_ENDPOINT, params)
                  .send_post_request
  end

  # Gets information about the Rosette API, returns name, version, build number
  # and build time.
  def info
    RequestBuilder.new(@user_key, @alternate_url + INFO)
                  .send_get_request
  end

  # Pings the Rosette API for a response indicting that the service is
  # available.
  def ping
    RequestBuilder.new(@user_key, @alternate_url + PING)
                  .send_get_request
  end

  private

    # Checks that the right parameter type is being passed in
    def check_params(params, message = 'Expects a DocumentParameters type as an argument', type = DocumentParameters)
      raise BadRequest.new message unless params.is_a? type
    end
end
