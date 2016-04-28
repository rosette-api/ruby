require '../lib/rosette_api'
require '../lib/document_parameters'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

params = DocumentParameters.new(content: 'Rechtsschutzversicherungsgesellschaften')
response = rosette_api.get_compound_components(params)
puts JSON.pretty_generate(response)