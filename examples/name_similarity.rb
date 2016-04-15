require '../rosette_api'
require '../parameters'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

params = Parameters.new
params.name1 = 'Michael Jackson'
params.name2 = '迈克尔·杰克逊'
response = rosette_api.name_similarity(params)
puts JSON.pretty_generate(response)