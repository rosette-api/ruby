require '../rosette_api'
require '../parameters'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

params = Parameters.new
params.name = 'معمر محمد أبو منيار القذاف'
params.target_language = 'eng'
params.target_script = 'Latn'
response = rosette_api.name_translation(params)
puts JSON.pretty_generate(response)