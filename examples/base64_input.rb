#!/usr/bin/env ruby

require "net/http"
require "net/https"
require "json"
require "base64"

api_key, url = ARGV
raise "API Key required" unless api_key

if !url
    url = "https://api.rosette.com/rest/v1/entities"
else
    url = url + "/entities"
end

uri = URI.parse(url)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true if uri.scheme == 'https'

request = Net::HTTP::Post.new(uri.request_uri)
request["user_key"] = api_key
request["Content-Type"] = "application/json"
request["Accept"] = "application/json"
entities_text_data = "Bill Murray will appear in new Ghostbusters film: Dr. Peter Venkman was spotted filming a cameo in Boston this… http://dlvr.it/BnsFfS"
content = {
	content: Base64.urlsafe_encode64(entities_text_data),
    contentType: "application/octet-stream"
}
JSONbody = content.to_json

request.body = JSONbody

response = http.request(request)

puts JSON.pretty_generate(JSON.parse(response.body))
