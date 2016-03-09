#!/usr/bin/env ruby
# encoding: utf-8

require "net/http"
require "net/https"
require "json"

api_key, url = ARGV
raise "API Key required" unless api_key

if !url
    url = "https://api.rosette.com/rest/v1/morphology/parts-of-speech"
else
    url = url + "/morphology/parts-of-speech"
end

uri = URI.parse(url)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true if uri.scheme == 'https'

request = Net::HTTP::Post.new(uri.request_uri)
request["X-RosetteAPI-Key"] = api_key
request["Content-Type"] = "application/json"
request["Accept"] = "application/json"
morphology_parts_of_speech_data = "The fact is that the geese just went back to get a rest and I'm not banking on their return soon"
content = {
    content: morphology_parts_of_speech_data
}
JSONbody = content.to_json

request.body = JSONbody

response = http.request(request)

puts JSON.pretty_generate(JSON.parse(response.body))
