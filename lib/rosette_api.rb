# frozen_string_literal: true

require_relative 'request_builder'
require_relative 'document_parameters'
require_relative 'name_deduplication_parameters'
require_relative 'name_translation_parameters'
require_relative 'name_similarity_parameters'
require_relative 'address_similarity_parameters'
require_relative 'rosette_api_error'
require_relative 'bad_request_error'
require_relative 'bad_request_format_error'
require 'logger'

# This class allows you to access all Rosette API endpoints.
class RosetteAPI
  # Version of Ruby binding
  BINDING_VERSION = '1.27.1'
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
  # Name Deduplication endpoint
  NAME_DEDUPLICATION_ENDPOINT = '/name-deduplication'
  # Rosette API name-translation endpoint
  NAME_TRANSLATION_ENDPOINT = '/name-translation'
  # Rosette API name-similarity endpoint
  NAME_SIMILARITY_ENDPOINT = '/name-similarity'
  # Rosette API address-similarity endpoint
  ADDRESS_SIMILARITY_ENDPOINT = '/address-similarity'
  # Rosette API tokens endpoint
  TOKENS_ENDPOINT = '/tokens'
  # Rosette API sentences endpoint
  SENTENCES_ENDPOINT = '/sentences'
  # Rosette API info endpoint
  INFO = '/info'
  # Rosette API ping endpoint
  PING = '/ping'
  # Text Embedding endpoint (deprecated)
  TEXT_EMBEDDING = '/text-embedding'
  # Semantic Vectors endpoint (replaces /text-embedding)
  SEMANTIC_VECTORS = '/semantics/vector'
  # Similar Terms endpoint
  SIMILAR_TERMS_ENDPOINT = '/semantics/similar'
  # Syntactic Dependencies endpoint
  SYNTACTIC_DEPENDENCIES_ENDPOINT = '/syntax/dependencies'
  # Transliteration endpoint
  TRANSLITERATION_ENDPOINT = '/transliteration'
  # Topics endpoint
  TOPICS_ENDPOINT = '/topics'

  # Rosette API key
  attr_accessor :user_key
  # Alternate Rosette API URL
  attr_accessor :alternate_url
  # custom Rosette API headers
  attr_accessor :custom_headers
  # URL query parameter(s)
  attr_accessor :url_parameters

  def initialize(user_key, alternate_url = 'https://api.rosette.com/rest/v1')
    @log = Logger.new($stdout)
    @user_key = user_key
    @alternate_url = alternate_url
    @url_parameters = nil

    @alternate_url = alternate_url.to_s.slice(0..-2) if @alternate_url.to_s.end_with?('/')

    uri = URI.parse alternate_url
    @http_client = Net::HTTP.new uri.host, uri.port
    @http_client.use_ssl = uri.scheme == 'https'
  end

  # Identifies in which language(s) the input is written.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns list of candidate languages in order of descending confidence.
  def get_language(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + LANGUAGE_ENDPOINT,
                       @http_client, BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  # Extracts parts-of-speech, lemmas (dictionary form), compound components,
  # and Han-readings for each token in the input.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns the lemmas, compound components, Han-readings, and parts-of-speech
  # tags of the input for supported languages.
  def get_morphology_complete(params)
    check_params params

    params = params.load_params

    endpoint = "#{MORPHOLOGY_ENDPOINT}/complete"
    RequestBuilder.new(@user_key, @alternate_url + endpoint, @http_client,
                       BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  # Extracts compound-components from the input.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns list of components for each compound word of the input for supported
  # languages.
  def get_compound_components(params)
    check_params params

    params = params.load_params

    endpoint = "#{MORPHOLOGY_ENDPOINT}/compound-components"
    RequestBuilder.new(@user_key, @alternate_url + endpoint, @http_client,
                       BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  # Extracts Han-readings from the input.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns list of Han-readings which provide pronunciation information for
  # Han script, in both Chinese and Japanese input text.
  def get_han_readings(params)
    check_params params

    params = params.load_params

    endpoint = "#{MORPHOLOGY_ENDPOINT}/han-readings"
    RequestBuilder.new(@user_key, @alternate_url + endpoint, @http_client,
                       BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  # Extracts lemmas from the input.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns list of lemmas for each token of the input for supported languages.
  def get_lemmas(params)
    check_params params

    params = params.load_params

    endpoint = "#{MORPHOLOGY_ENDPOINT}/lemmas"
    RequestBuilder.new(@user_key, @alternate_url + endpoint, @http_client,
                       BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  # Extracts parts-of-speech from the input.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns list of part-of-speech (POS) tags for each of the words of the
  # input, depending on the context of how it is used.
  def get_parts_of_speech(params)
    check_params params

    params = params.load_params

    endpoint = "#{MORPHOLOGY_ENDPOINT}/parts-of-speech"
    RequestBuilder.new(@user_key, @alternate_url + endpoint, @http_client,
                       BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  # Extracts entities from the input.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns each entity extracted from the input.
  def get_entities(params)
    check_params params

    params = params.load_params

    endpoint = ENTITIES_ENDPOINT
    RequestBuilder.new(@user_key, @alternate_url + endpoint, @http_client,
                       BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  # Extracts Tier 1 contextual categories from the input.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns the contextual categories identified in the input.
  def get_categories(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + CATEGORIES_ENDPOINT,
                       @http_client, BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  # Extracts relationships from the input.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns each relationship extracted from the input.
  def get_relationships(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + RELATIONSHIPS_ENDPOINT,
                       @http_client, BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  # Analyzes the positive and negative sentiment expressed by the input.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns sentiment analysis results.
  def get_sentiment(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + SENTIMENT_ENDPOINT,
                       @http_client, BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  # De-duplicates a list of names.
  #
  # ==== Attributes
  #
  # * +params+ - NameDeduplicationParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns the list of deduplicated names.
  def get_name_deduplication(params)
    check_params params,
                 'Expects a NameDeduplicationParameters type as an argument',
                 NameDeduplicationParameters

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + NAME_DEDUPLICATION_ENDPOINT,
                       @http_client, BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  # Translates a given name to a supported specified language.
  #
  # ==== Attributes
  #
  # * +params+ - NameTranslationParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns the translation of a name.
  def get_name_translation(params)
    check_params params,
                 'Expects a NameTranslationParameters type as an argument',
                 NameTranslationParameters

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + NAME_TRANSLATION_ENDPOINT,
                       @http_client, BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  # Compares two entity names (person, location, or organization) and returns a
  # match score from 0 to 1.
  #
  # ==== Attributes
  #
  # * +params+ - NameSimilarityParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns the confidence score of matching 2 names.
  def get_name_similarity(params)
    check_params params,
                 'Expects a NameSimilarityParameters type as an argument',
                 NameSimilarityParameters

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + NAME_SIMILARITY_ENDPOINT,
                       @http_client, BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  # Compares two addresses and returns a match score from 0 to 1.
  #
  # ==== Attributes
  #
  # * +params+ - AddressSimilarityParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns the confidence score of matching 2 addresses.
  def get_address_similarity(params)
    check_params params,
                 'Expects a AddressSimilarityParameters type as an argument',
                 AddressSimilarityParameters

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + ADDRESS_SIMILARITY_ENDPOINT,
                       @http_client, BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  # Divides the input into tokens.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns list of tokens of the input.
  def get_tokens(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + TOKENS_ENDPOINT,
                       @http_client, BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  # Divides the input into sentences.
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns list of linguistic sentences of the input.
  def get_sentences(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + SENTENCES_ENDPOINT,
                       @http_client, BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  #
  # Returns the vectors associated with the text
  #
  # Deprecated.  Please use `get_semantic_vectors` instead
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns the text embedding representation of the input.
  def get_text_embedding(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + TEXT_EMBEDDING, @http_client,
                       BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  #
  # Returns the vectors associated with the text
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns the text embedding representation of the input.
  def get_semantic_vectors(params)
    check_params params
    params = params.load_params
    RequestBuilder.new(@user_key, @alternate_url + SEMANTIC_VECTORS,
                       @http_client, BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  #
  # Returns the syntactic structure of the text
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns list of linguistic sentences of the input.
  def get_syntax_dependencies(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key,
                       @alternate_url + SYNTACTIC_DEPENDENCIES_ENDPOINT,
                       @http_client, BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  #
  # Returns the transliteration of the content
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns the transliteration of the input.
  def get_transliteration(params)
    check_params params,
                 'Expects a DocumentParameters type as an argument',
                 DocumentParameters

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + TRANSLITERATION_ENDPOINT,
                       @http_client, BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  # Divides the input into topics (key phrases and concepts).
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns list of topics of the input.
  def get_topics(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + TOPICS_ENDPOINT,
                       @http_client, BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  # Returns the terms similar to the input
  #
  # ==== Attributes
  #
  # * +params+ - DocumentParameters helps to build the request body in
  #   RequestBuilder.
  #
  # Returns a mapping of languageCode to similar terms
  def get_similar_terms(params)
    check_params params

    params = params.load_params

    RequestBuilder.new(@user_key, @alternate_url + SIMILAR_TERMS_ENDPOINT,
                       @http_client, BINDING_VERSION, params, @url_parameters)
                  .send_post_request
  end

  # Gets information about the Rosette API, returns name, build number
  # and build time.
  def info
    RequestBuilder.new(@user_key, @alternate_url + INFO, @http_client,
                       BINDING_VERSION, @url_parameters)
                  .send_get_request
  end

  # Pings the Rosette API for a response indicting that the service is
  # available.
  def ping
    RequestBuilder.new(@user_key, @alternate_url + PING, @http_client,
                       BINDING_VERSION, @url_parameters)
                  .send_get_request
  end

  # Gets the User-Agent string
  def user_agent
    RequestBuilder.new(@user_key, @alternate_url + PING, @http_client,
                       BINDING_VERSION, @url_parameters).user_agent
  end

  private

  # Checks that the right parameter type is being passed in.
  def check_params(params,
                   message = 'Expects a DocumentParameters type as an argument',
                   type = DocumentParameters)
    raise BadRequestError.new message unless params.is_a? type

    return unless defined?(params.genre) && !params.genre.nil?

    @log.warn('The genre parameter is deprecated and will be removed in a future release.')
  end
end
