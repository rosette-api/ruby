require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

morphology_parts_of_speech_data = "The fact is that the geese just went back to get a rest and I'm not banking on their return soon"
params = DocumentParameters.new(content: morphology_parts_of_speech_data)
response = rosette_api.get_parts_of_speech(params)
puts JSON.pretty_generate(response)