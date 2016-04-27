require '../rosette_api/rosette_api'
require '../rosette_api/document_parameters'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

params = DocumentParameters.new(content: 'The Ghostbusters movie was filmed in Boston.')
response = rosette_api.get_relationships(params)
puts JSON.pretty_generate(response)