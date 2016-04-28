require '../lib/rosette_api'
require '../lib/document_parameters'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

params = DocumentParameters.new(content: 'Por favor Señorita, says the man.?')
response = rosette_api.get_language(params)
puts JSON.pretty_generate(response)