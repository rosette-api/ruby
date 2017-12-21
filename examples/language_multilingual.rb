require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

language_multilingual_data = 'TBD'
begin
  params = DocumentParameters.new(content: language_multilingual_data)
  params.rosette_options = { 'multilingual' => 'true' }
  params.custom_headers = { 'X-RosetteAPI-App' => 'ruby-app' }
  response = rosette_api.get_language(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => rosette_api_error
  printf('Rosette API Error (%s): %s', rosette_api_error.status_code, rosette_api_error.message)
end
