require '../rosette_api'
require '../name_similarity_parameters'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

params = NameSimilarityParameters.new
params.name1 = {:text => 'Michael Jackson', :language => 'eng', :entityType => 'PERSON'}
params.name2 = {:text => '迈克尔·杰克逊', :entityType => 'PERSON'}
response = rosette_api.name_similarity(params)
puts JSON.pretty_generate(response)