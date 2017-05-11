require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

matched_name_data1 = 'Michael Jackson'
matched_name_data2 = '迈克尔·杰克逊'
begin
  name1 = NameParameter.new(matched_name_data1, entity_type: 'PERSON', language: 'eng')
  params = NameSimilarityParameters.new(name1, matched_name_data2)
  response = rosette_api.get_name_similarity(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => rosette_api_error
  printf('Rosette API Error (%s): %s', rosette_api_error.status_code, rosette_api_error.message)
end
