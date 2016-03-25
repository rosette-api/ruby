#!/usr/bin/env ruby
# encoding: utf-8

require "net/http"
require "net/https"
require "json"

api_key, url = ARGV
raise "API Key required" unless api_key

if !url
    url = "https://api.rosette.com/rest/v1/morphology/compound-components"
else
    url = url + "/morphology/compound-components"
end

uri = URI.parse(url)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true if uri.scheme == 'https'

request = Net::HTTP::Post.new(uri.request_uri)
request["X-RosetteAPI-Key"] = api_key
request["Content-Type"] = "application/json"
request["Accept"] = "application/json"
morphology_compound_components_data = "Rechtsschutzversicherungsgesellschaften"
content = {
    content: morphology_compound_components_data
}
JSONbody = content.to_json

request.body = JSONbody

response = http.request(request)

puts JSON.pretty_generate(JSON.parse(response.body))
