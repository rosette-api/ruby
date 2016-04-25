require 'net/http'
require 'net/https'
require 'json'
require 'securerandom'
require_relative 'rosette_api_error'

class RequestBuilder
  attr_reader :alternate_url, :params, :user_key

  def initialize(user_key, alternate_url, params = {})
    @user_key = user_key
    @alternate_url = alternate_url
    @params = params
  end

  def prepare_plain_request(params)
    uri = URI.parse @alternate_url
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = uri.scheme == 'https'

    request = Net::HTTP::Post.new uri.request_uri
    request['X-RosetteAPI-Key'] = @user_key
    request['Content-Type'] = 'application/json'
    request['Accept'] = 'application/json'
    request.body = params.to_json

    [http, request]
  end

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
    uri = URI.parse @alternate_url
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = uri.scheme == 'https'
    request = Net::HTTP::Post.new uri.request_uri
    request.add_field 'Content-Type', "multipart/form-data; boundary=#{boundary}"
    request.add_field 'X-RosetteAPI-Key', @user_key
    request.body = post_body.join

    [http, request]
  end

  def send_get_request
    uri = URI.parse @alternate_url
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = uri.scheme == 'https'

    request = Net::HTTP::Get.new uri.request_uri
    request['X-RosetteAPI-Key'] = @user_key

    self.get_response http, request
  end

  def send_post_request
    if @alternate_url.to_s.include? '/info?clientVersion='
      params = '{"body": "version check"}'
    else
      params = @params
    end

    if !params['filePath'].nil?
      http, request = self.prepare_multipart_request params
    else
      http, request = self.prepare_plain_request params
    end

    self.get_response http, request
  end

  def get_response(http, request)
    response = http.request request

    if response.code != '200'
      message =
          if JSON.parse(response.body)['message'].nil?
            response.body
          else
            JSON.parse(response.body)['message']
          end

      raise RosetteAPIError.new response.code, message
    else
      response_headers = {}
      response.header.each_header { |key, value| response_headers[key] = value }
      response_headers = { responseHeaders: response_headers }

      JSON.parse(response.body).merge(response_headers)
    end
  end
end
