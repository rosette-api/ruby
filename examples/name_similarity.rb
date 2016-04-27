require '../rosette_api/rosette_api'
require '../rosette_api/name_similarity_parameters'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end


name1 = NameParameter.new('Michael Jackson', entity_type: 'PERSON', language:'eng')
params = NameSimilarityParameters.new(name1, '迈克尔·杰克逊')
response = rosette_api.name_similarity(params)
puts JSON.pretty_generate(response)