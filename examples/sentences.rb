#!/usr/bin/env ruby

require "net/http"
require "net/https"
require "json"

api_key, url = ARGV
raise "API Key required" unless api_key

if !url
    url = "https://api.rosette.com/rest/v1/sentences"
else
    url = url + "/sentences"
end

uri = URI.parse(url)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true if uri.scheme == 'https'

request = Net::HTTP::Post.new(uri.request_uri)
request["user_key"] = api_key
request["Content-Type"] = "application/json"
request["Accept"] = "application/json"
sentences_data = "This land is your land. This land is my land\nFrom California to the New York island;\nFrom the red wood forest to the Gulf Stream waters\n\nThis land was made for you and Me.\n\nAs I was walking that ribbon of highway,\nI saw above me that endless skyway:\nI saw below me that golden valley:\nThis land was made for you and me."
content = {
    content: sentences_data
}
JSONbody = content.to_json

request.body = JSONbody

response = http.request(request)

puts JSON.pretty_generate(JSON.parse(response.body))
