require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

syntax_dependencies_data = "Sony Pictures is planning to shoot a good portion of the new \"Ghostbusters\" in Boston as well."
params = DocumentParameters.new(content: syntax_dependencies_data, genre: 'social-media')
response = rosette_api.get_syntax_dependencies(params)
puts JSON.pretty_generate(response)
