require '../rosette_api'
require '../name_similarity_parameters'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

params = NameSimilarityParameters.new
name1 = NameParameter.new('Michael Jackson')
name1.entity_type = 'PERSON'
name1.language = 'eng'
params.name1 = name1
params.name2 = '迈克尔·杰克逊'
response = rosette_api.name_similarity(params)
puts JSON.pretty_generate(response)