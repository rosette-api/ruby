require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

params = NameTranslationParameters.new('معمر محمد أبو منيار القذاف', 'eng', target_script: 'Latn')
response = rosette_api.name_translation(params)
puts JSON.pretty_generate(response)