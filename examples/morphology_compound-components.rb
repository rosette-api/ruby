require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

morphology_compound_components_data = "Rechtsschutzversicherungsgesellschaften"
params = DocumentParameters.new(content: morphology_compound_components_data)
response = rosette_api.get_compound_components(params)
puts JSON.pretty_generate(response)