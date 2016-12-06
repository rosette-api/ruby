require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end
response = rosette_api.info
begin
    puts JSON.pretty_generate(response)
rescue RosetteAPIError => rosette_api_error
    printf("Rosette API Error (%s): %s", rosette_api_error.status_code, rosette_api_error.message)
end
