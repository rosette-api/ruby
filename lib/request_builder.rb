# frozen_string_literal: true

require 'net/http'
require 'net/https'
require 'json'
require 'securerandom'
require_relative 'rosette_api_error'

# This class handles all Rosette API requests.
class RequestBuilder
  # Alternate Rosette API URL
  attr_reader :alternate_url
  # Rosette API HTTP client
  attr_reader :http_client
  # Parameters to build the body of the request from
  attr_accessor :params
  # Rosette API key
  attr_accessor :user_key
  # Rosette API binding version
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

  # Prepares a plain POST request for Rosette API.
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
        'connectionError',
        'Failed to establish connection with Rosette server.'
      )
    end

    custom_headers = params['customHeaders']

    if custom_headers
      keys_array = custom_headers.keys
      keys_array.each do |key|
        if key.to_s =~ /^X-RosetteAPI-/
          request[key] = custom_headers[key]
        else
          raise RosetteAPIError.new(
            'invalidHeader',
            'Custom header must begin with "X-RosetteAPI-"'
          )
        end
      end
      params.delete 'customHeaders'
    end

    request['X-RosetteAPI-Key'] = @user_key
    request['Content-Type'] = 'application/json'
    request['Accept'] = 'application/json'
    request['User-Agent'] = @user_agent
    request['X-RosetteAPI-Binding'] = 'ruby'
    request['X-RosetteAPI-Binding-Version'] = @binding_version
    request.body = params.to_json

    [@http_client, request]
  end

  # Prepares a multipart/form-data POST request for Rosette API.
  #
  # ==== Attributes
  #
  # * +params+ - Parameters to build the body of the request.
  #
  # Returns a HTTP connection and the built POST request.
  def prepare_multipart_request(params)
    begin
      file = File.open params['filePath'], 'r'
      text = file.read
    rescue StandardError => e
      raise RosetteAPIError.new('readMultipartError', e)
    end

    boundary = SecureRandom.hex
    post_body = []
    params.delete 'filePath'
    request_file = params.to_json

    # Add the content data
    post_body << "--#{boundary}\r\n"
    post_body << 'Content-Disposition: form-data; name="content"; ' \
                 "filename=\"#{File.basename(file)}\"\r\n"
    post_body << "Content-Type: text/plain\r\n\r\n"
    post_body << text

    # Add the request data
    post_body << "\r\n\r\n--#{boundary}\r\n"
    post_body << "Content-Disposition: form-data; name=\"request\"\r\n"
    post_body << "Content-Type: application/json\r\n\r\n"
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
        'connectionError',
        'Failed to establish connection with Rosette API server.'
      )
    end

    # add any custom headers from the user
    unless params['customHeaders'].nil?
      keys_array = params['customHeaders'].keys
      keys_array.each do |k|
        if k.to_s =~ /^X-RosetteAPI-/
          request.add_field k, params['customHeaders'][k]
        else
          raise RosetteAPIError.new(
            'invalidHeader',
            'Custom header must begin with "X-RosetteAPI-"'
          )
        end
      end
      params.delete 'customHeaders'
    end

    request.add_field 'Content-Type',
                      "multipart/form-data; boundary=#{boundary}"
    request.add_field 'User-Agent', @user_agent
    request.add_field 'X-RosetteAPI-Key', @user_key
    request.add_field 'X-RosetteAPI-Binding', 'ruby'
    request.add_field 'X-RosetteAPI-Binding-Version', @binding_version
    request.body = post_body.join

    [@http_client, request]
  end

  # Sends a GET request to Rosette API.
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
        'connectionError',
        'Failed to establish connection with Rosette API server.'
      )
    end
    request['X-RosetteAPI-Key'] = @user_key
    request['User-Agent'] = @user_agent

    get_response @http_client, request
  end

  # Sends a POST request to Rosette API.
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
  # * +request+ - Prepared Rosette API request.
  #
  # Returns JSON response or raises RosetteAPIError if encountered.
  def get_response(http, request)
    response = http.request request

    if response.code != '200'
      message = JSON.parse(response.body)['message']
      code = JSON.parse(response.body)['code']
      raise RosetteAPIError.new code, message
    else
      response_headers = {}
      response.header.each_header { |key, value| response_headers[key] = value }
      response_headers = { responseHeaders: response_headers }

      JSON.parse(response.body).merge(response_headers)
    end
  end
end
