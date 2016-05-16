require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

translated_name_data = 'معمر محمد أبو منيار القذاف'
params = NameTranslationParameters.new(translated_name_data, 'eng', target_script: 'Latn')
response = rosette_api.name_translation(params)
puts JSON.pretty_generate(response)