require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

relationships_text_data = "Bill Gates, Microsoft's former CEO, is a philanthropist."
params = DocumentParameters.new(content: relationships_text_data)
params.rosette_options = { accuracyMode: 'PRECISION' }
response = rosette_api.get_relationships(params)
puts JSON.pretty_generate(response)
