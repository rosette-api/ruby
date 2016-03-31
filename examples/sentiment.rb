#!/usr/bin/env ruby
# encoding: utf-8

require "net/http"
require "net/https"
require "json"
require 'tempfile'
require 'securerandom'

api_key, url = ARGV
raise "API Key required" unless api_key

if !url
    url = "https://api.rosette.com/rest/v1/sentiment"
else
    url = url + "/sentiment"
end

file = Tempfile.new(['foo', '.html'])
sentiment_file_data ="<html><head><title>New Ghostbusters Film</title></head><body><p>Original Ghostbuster Dan Aykroyd, who also co-wrote the 1984 Ghostbusters film, couldn’t be more pleased with the new all-female Ghostbusters cast, telling The Hollywood Reporter, The Aykroyd family is delighted by this inheritance of the Ghostbusters torch by these most magnificent women in comedy.</p></body></html>"
file.write(sentiment_file_data)
file.open
request_file = {:language => "eng"}

uri = URI.parse(url)
BOUNDARY = SecureRandom.hex
post_body = []

# Add the content data
post_body << "--#{BOUNDARY}\r\n"
post_body << "Content-Disposition: form-data; name=\"content\"; filename=\"#{File.basename(file)}\"\r\n"
post_body << "Content-Type: text/plain\r\n\r\n"
post_body << file.read

# Add the request data
post_body << "\r\n\r\n--#{BOUNDARY}\r\n"
post_body << "Content-Disposition: form-data; name=\"request\"\r\n"
post_body << "Content-Type: application/json\r\n\r\n"
post_body << request_file.to_json
post_body << "\r\n\r\n--#{BOUNDARY}--\r\n"

# Create the HTTP objects
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true if uri.scheme == 'https'
request = Net::HTTP::Post.new(uri.request_uri)
request.add_field("Content-Type",  "multipart/form-data; boundary=#{BOUNDARY}")
request.add_field("X-RosetteAPI-Key", api_key)
request.body = post_body.join

# Send the request
response = http.request(request)
response_headers = {}
response.header.each_header {|key,value| response_headers[key] = value}
response_headers = {"responseHeaders" => response_headers}
puts JSON.pretty_generate(JSON.parse(response.body).merge(response_headers))
