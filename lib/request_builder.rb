# encoding: UTF-8
require 'net/http'
require 'net/https'
require 'json'
require 'securerandom'
require_relative 'rosette_api_error'

# This class handles all Rosette API requests.
class RequestBuilder
  # Alternate Rosette API URL
  attr_reader :alternate_url
  # Parameters to build the body of the request from
  attr_accessor :params
  # Rosette API key
  attr_accessor :user_key
  # Rosette API binding version
  attr_accessor :binding_version

  def initialize(user_key, alternate_url, params = {}, binding_version) #:notnew:
    @user_key = user_key
    @alternate_url = alternate_url
    @params = params
    @retries = 5
    @binding_version = binding_version
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
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = uri.scheme == 'https'
      request = Net::HTTP::Post.new uri.request_uri
    rescue
      raise RosetteAPIError.new 'connectionError', 'Failed to establish connection with Rosette API server.'
    end

    if params["customHeaders"] != nil
      keys_array = params["customHeaders"].keys
      for k in keys_array
        if k.to_s =~ /^X-RosetteAPI-/
          request[k] = params['customHeaders'][k]
        else
            raise RosetteAPIError.new 'invalidHeader', 'Custom header must begin with "X-RosetteAPI-"'
        end
      end
      params.delete "customHeaders"
    end

    request['X-RosetteAPI-Key'] = @user_key
    request['Content-Type'] = 'application/json'
    request['Accept'] = 'application/json'
    request['X-RosetteAPI-Binding'] = 'ruby'
    request['X-RosetteAPI-Binding-Version'] = @binding_version
    request.body = params.to_json

    [http, request]
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
    rescue => err
      raise err
    end

    boundary = SecureRandom.hex
    post_body = []
    request_file = params.to_json

    # Add the content data
    post_body << "--#{boundary}\r\n"
    post_body << "Content-Disposition: form-data; name=\"content\"; filename=\"#{File.basename(file)}\"\r\n"
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
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = uri.scheme == 'https'
      request = Net::HTTP::Post.new uri.request_uri
    rescue
      raise RosetteAPIError.new 'connectionError', 'Failed to establish connection with Rosette API server.'
    end
    
    # add any custom headers from the user
    if params["customHeaders"] != nil
      keys_array = params["customHeaders"].keys
      for k in keys_array
        if k.to_s =~ /^X-RosetteAPI-/
          request.add_field k, params['customHeaders'][k]
        else
            raise RosetteAPIError.new 'invalidHeader', 'Custom header must begin with "X-RosetteAPI-"'
        end
      end
      params.delete "customHeaders"
    end

    request.add_field 'Content-Type', "multipart/form-data; boundary=#{boundary}"
    request.add_field 'X-RosetteAPI-Key', @user_key
    request.add_field 'X-RosetteAPI-Binding', 'ruby'
    request.add_field 'X-RosetteAPI-Binding-Version', @binding_version
    request.body = post_body.join

    [http, request]
  end

  # Sends a GET request to Rosette API.
  #
  # Returns JSON response or raises RosetteAPIError if encountered.
  def send_get_request
    begin
      uri = URI.parse @alternate_url
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = uri.scheme == 'https'

      request = Net::HTTP::Get.new uri.request_uri
    rescue
      raise RosetteAPIError.new 'connectionError', 'Failed to establish connection with Rosette API server.'
    end
    request['X-RosetteAPI-Key'] = @user_key

    self.get_response http, request
  end

  # Sends a POST request to Rosette API.
  #
  # Returns JSON response or raises RosetteAPIError if encountered.
  def send_post_request
    if !params['filePath'].nil?
      http, request = self.prepare_multipart_request params
    else
      http, request = self.prepare_plain_request params
    end

    self.get_response http, request
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
      if response.code == '429'
        if @retries != 0
          @retries = @retries - 1
          sleep 15
          self.get_response(http, request)
        else
          raise RosetteAPIError.new code, message
        end
      else
        raise RosetteAPIError.new code, message
      end
    else
      response_headers = {}
      response.header.each_header { |key, value| response_headers[key] = value }
      response_headers = { responseHeaders: response_headers }

      JSON.parse(response.body).merge(response_headers)
    end
  end
end
