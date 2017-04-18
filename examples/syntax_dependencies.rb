require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

syntax_dependencies_data = 'Yoshinori Ohsumi, a Japanese cell biologist, was awarded the Nobel Prize in Physiology or Medicine on Monday.'
begin
  params = DocumentParameters.new(content: syntax_dependencies_data)
  response = rosette_api.get_syntax_dependencies(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => rosette_api_error
  printf('Rosette API Error (%s): %s', rosette_api_error.status_code, rosette_api_error.message)
end
