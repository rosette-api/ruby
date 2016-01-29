#!/usr/bin/env ruby

require "net/http"
require "net/https"
require "json"

api_key, url = ARGV
raise "API Key required" unless api_key

if !url
    url = "https://api.rosette.com/rest/v1/categories"
else
    url = url + "/categories"
end

uri = URI.parse(url)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true if uri.scheme == 'https'

request = Net::HTTP::Post.new(uri.request_uri)
request["user_key"] = api_key
request["Content-Type"] = "application/json"
request["Accept"] = "application/json"
categories_url_data = "http://www.onlocationvacations.com/2015/03/05/the-new-ghostbusters-movie-begins-filming-in-boston-in-june/"
content = {
    contentUri: categories_url_data
}
JSONbody = content.to_json

request.body = JSONbody

response = http.request(request)

puts JSON.pretty_generate(JSON.parse(response.body))
