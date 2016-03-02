#!/usr/bin/env ruby
# encoding: utf-8

require "net/http"
require "net/https"
require "json"

api_key, url = ARGV
raise "API Key required" unless api_key

if !url
    url = "https://api.rosette.com/rest/v1/info"
else
    url = url + "/info"
end

uri = URI.parse(url)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true if uri.scheme == 'https'

request = Net::HTTP::Get.new(uri.request_uri)
request["user_key"] = api_key

response = http.request(request)

puts JSON.pretty_generate(JSON.parse(response.body))
