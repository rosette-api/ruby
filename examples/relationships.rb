require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

relationships_text_data = "Bill Gates, Microsoft's former CEO, is a philanthropist."
begin
  params = DocumentParameters.new(content: relationships_text_data)
  params.rosette_options = { accuracyMode: 'PRECISION' }
  response = rosette_api.get_relationships(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => rosette_api_error
  printf('Rosette API Error (%s): %s', rosette_api_error.status_code, rosette_api_error.message)
end
