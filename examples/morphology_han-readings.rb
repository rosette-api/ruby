#!/usr/bin/env ruby

require "net/http"
require "net/https"
require "json"

uri = URI.parse("https://api.rosette.com/rest/v1/morphology/han-readings")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true if uri.scheme == 'https'

request = Net::HTTP::Post.new(uri.request_uri)
request["user_key"] = ARGV[0] # your api key
request["Content-Type"] = "application/json"
request["Accept"] = "application/json"
morphology_han_readings_data = "北京大学生物系主任办公室内部会议"
content = {
    content: morphology_han_readings_data
}
JSONbody = content.to_json

request.body = JSONbody

response = http.request(request)

puts JSON.pretty_generate(JSON.parse(response.body))
