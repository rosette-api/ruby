require '../rosette_api'
require '../document_parameters'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

params = DocumentParameters.new
params.content = 'The quick brown fox jumped over the lazy dog. Yes he did.'
response = rosette_api.get_morphology_complete(params)
puts JSON.pretty_generate(response)
