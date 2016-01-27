#!/usr/bin/env ruby

require "net/http"
require "net/https"
require "json"
require "base64"

uri = URI.parse("https://api.rosette.com/rest/v1/entities")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true if uri.scheme == 'https'

request = Net::HTTP::Post.new(uri.request_uri)
request["user_key"] = ARGV[0] # your api key
request["Content-Type"] = "text/html"
request["Accept"] = "application/json"
entities_text_data = "Sample"
content = {
	content: Base64.urlsafe_encode64(entities_text_data),
    contentType: "application/octet-stream"
}
JSONbody = content.to_json

request.body = JSONbody

response = http.request(request)

puts JSON.pretty_generate(JSON.parse(response.body))
