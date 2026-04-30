# frozen_string_literal: true

require 'net/http'
require 'net/https'
require 'json'
require 'securerandom'
require_relative 'rosette_api_error'

# This class handles all Analytics API requests.
class RequestBuilder
  CONNECTION_ERROR_CODE = 'connectionError'
  CONNECTION_ERROR_MESSAGE = 'Failed to establish connection with Analytics server.'

  INVALID_HEADER_CODE = 'invalidHeader'
  INVALID_HEADER_MESSAGE = 'Custom header must begin with "X-RosetteAPI-" or "X-BabelStreetAPI-"'

  READ_MULTIPART_ERROR_CODE = 'readMultipartError'

  HEADER_API_KEY = 'X-BabelStreetAPI-Key'
  HEADER_CONTENT_TYPE = 'Content-Type'
  HEADER_ACCEPT = 'Accept'
  HEADER_USER_AGENT = 'User-Agent'
  HEADER_BINDING_LEGACY = 'X-RosetteAPI-Binding'
  HEADER_BINDING = 'X-BabelStreetAPI-Binding'
  HEADER_BINDING_VERSION_LEGACY = 'X-RosetteAPI-Binding-Version'
  HEADER_BINDING_VERSION = 'X-BabelStreetAPI-Binding-Version'

  BINDING_NAME = 'ruby'

  CONTENT_TYPE_JSON = 'application/json'
  CONTENT_TYPE_TEXT_PLAIN = 'text/plain'
  ACCEPT_JSON = 'application/json'

  MULTIPART_FORM_DATA = 'multipart/form-data'

  CUSTOM_HEADER_PREFIX_ROSETTE = /^X-RosetteAPI-/
  CUSTOM_HEADER_PREFIX_BABELSTREET = /^X-BabelStreetAPI-/

  # Alternate API URL
  attr_reader :alternate_url
  # API HTTP client
  attr_reader :http_client
  # Parameters to build the body of the request from
  attr_accessor :params
  # API key
  attr_accessor :user_key
  # API binding version
  attr_accessor :binding_version
  # User-Agent string
  attr_reader :user_agent

  def initialize(user_key, alternate_url, http_client, binding_version,
                 params = {}, url_parameters = nil)
    @user_key = user_key
    @alternate_url = alternate_url
    @http_client = http_client
    @binding_version = binding_version
    @params = params
    @user_agent = "Ruby/#{binding_version}/#{RUBY_VERSION}"

    return unless url_parameters

    @alternate_url = "#{@alternate_url}?#{URI.encode_www_form(url_parameters)}"
  end

  # Prepares a plain POST request for Analytics API.
  #
  # ==== Attributes
  #
  # * +params+ - Parameters to build the body of the request.
  #
  # Returns a HTTP connection and the built POST request.
  def prepare_plain_request(params)
    begin
      uri = URI.parse @alternate_url
      request = Net::HTTP::Post.new uri.request_uri
    rescue StandardError
      # Not ideal.  Consider switching to a different library.
      # https://stackoverflow.com/a/11802674
      raise RosetteAPIError.new(
        CONNECTION_ERROR_CODE,
        CONNECTION_ERROR_MESSAGE
      )
    end

    custom_headers = params['customHeaders']

    if custom_headers
      keys_array = custom_headers.keys
      keys_array.each do |key|
        if key.to_s =~ CUSTOM_HEADER_PREFIX_ROSETTE || key.to_s =~ CUSTOM_HEADER_PREFIX_BABELSTREET
          request[key] = custom_headers[key]
        else
          raise RosetteAPIError.new(
            INVALID_HEADER_CODE,
            INVALID_HEADER_MESSAGE
          )
        end
      end
      params.delete 'customHeaders'
    end

    request[HEADER_API_KEY] = @user_key
    request[HEADER_CONTENT_TYPE] = CONTENT_TYPE_JSON
    request[HEADER_ACCEPT] = ACCEPT_JSON
    request[HEADER_USER_AGENT] = @user_agent
    request[HEADER_BINDING_LEGACY] = BINDING_NAME
    request[HEADER_BINDING] = BINDING_NAME
    request[HEADER_BINDING_VERSION_LEGACY] = @binding_version
    request[HEADER_BINDING_VERSION] = @binding_version
    request.body = params.to_json

    [@http_client, request]
  end

  # Prepares a multipart/form-data POST request for Analytics API.
  #
  # ==== Attributes
  #
  # * +params+ - Parameters to build the body of the request.
  #
  # Returns a HTTP connection and the built POST request.
  def prepare_multipart_request(params)
    text = read_multipart_file params['filePath']

    boundary = SecureRandom.hex
    post_body = []

    # Add the content data
    post_body << "--#{boundary}\r\n"
    post_body << 'Content-Disposition: form-data; name="content"; ' \
                 "filename=\"#{File.basename(params['filePath'])}\"\r\n"
    post_body << "#{HEADER_CONTENT_TYPE}: #{CONTENT_TYPE_TEXT_PLAIN}\r\n\r\n"
    post_body << text

    # Add the request data
    params.delete 'filePath'
    request_file = params.to_json

    post_body << "\r\n\r\n--#{boundary}\r\n"
    post_body << "Content-Disposition: form-data; name=\"request\"\r\n"
    post_body << "#{HEADER_CONTENT_TYPE}: #{CONTENT_TYPE_JSON}\r\n\r\n"
    post_body << request_file
    post_body << "\r\n\r\n--#{boundary}--\r\n"

    # Create the HTTP objects
    begin
      uri = URI.parse @alternate_url
      request = Net::HTTP::Post.new uri.request_uri
    rescue StandardError
      # Not ideal.  Consider switching to a different library.
      # https://stackoverflow.com/a/11802674
      raise RosetteAPIError.new(
        CONNECTION_ERROR_CODE,
        CONNECTION_ERROR_MESSAGE
      )
    end

    # add any custom headers from the user
    unless params['customHeaders'].nil?
      keys_array = params['customHeaders'].keys
      keys_array.each do |k|
        if k.to_s =~ CUSTOM_HEADER_PREFIX_ROSETTE || k.to_s =~ CUSTOM_HEADER_PREFIX_BABELSTREET
          request.add_field k, params['customHeaders'][k]
        else
          raise RosetteAPIError.new(
            INVALID_HEADER_CODE,
            INVALID_HEADER_MESSAGE
          )
        end
      end
      params.delete 'customHeaders'
    end

    request.add_field HEADER_CONTENT_TYPE,
                      "#{MULTIPART_FORM_DATA}; boundary=#{boundary}"
    request.add_field HEADER_USER_AGENT, @user_agent
    request.add_field HEADER_API_KEY, @user_key
    request.add_field HEADER_BINDING_LEGACY, BINDING_NAME
    request.add_field HEADER_BINDING, BINDING_NAME
    request.add_field HEADER_BINDING_VERSION_LEGACY, @binding_version
    request.add_field HEADER_BINDING_VERSION, @binding_version
    request.body = post_body.join

    [@http_client, request]
  end

  # Reads the content of a file given its path.
  #
  # Returns the content of the file or raises error if encountered.
  def read_multipart_file(file_path)
    File.open(file_path, 'r') do |f|
      return f.read
    end
  rescue StandardError => e
    raise RosetteAPIError.new(READ_MULTIPART_ERROR_CODE, e)
  end

  # Sends a GET request to Analytics API.
  #
  # Returns JSON response or raises RosetteAPIError if encountered.
  def send_get_request
    begin
      uri = URI.parse @alternate_url
      request = Net::HTTP::Get.new uri.request_uri
    rescue StandardError
      # Not ideal.  Consider switching to a different library.
      # https://stackoverflow.com/a/11802674
      raise RosetteAPIError.new(
        CONNECTION_ERROR_CODE,
        CONNECTION_ERROR_MESSAGE
      )
    end
    request[HEADER_API_KEY] = @user_key
    request[HEADER_USER_AGENT] = @user_agent

    get_response @http_client, request
  end

  # Sends a POST request to Analytics API.
  #
  # Returns JSON response or raises RosetteAPIError if encountered.
  def send_post_request
    if params['filePath']
      http, request = prepare_multipart_request params
    else
      http, request = prepare_plain_request params
    end

    get_response http, request
  end

  # Gets response from HTTP connection.
  #
  # ==== Attributes
  #
  # * +http+ - HTTP connection.
  #
  # * +request+ - Prepared API request.
  #
  # Returns JSON response or raises RosetteAPIError if encountered.
  def get_response(http, request)
    response = http.request request

    if response.code == '200'
      response_headers = {}
      response.header.each_header { |key, value| response_headers[key] = value }
      response_headers = { responseHeaders: response_headers }

      JSON.parse(response.body).merge(response_headers)
    else
      parsed_body = JSON.parse(response.body)
      message = parsed_body['message']
      code = parsed_body['code']
      raise RosetteAPIError.new code, message
    end
  end
end
