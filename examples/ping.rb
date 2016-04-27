require '../rosette_api/rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end
response = rosette_api.ping
puts JSON.pretty_generate(response)