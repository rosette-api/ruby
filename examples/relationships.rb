require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

relationships_text_data = 'The Ghostbusters movie was filmed in Boston.'
params = DocumentParameters.new(content: relationships_text_data)
options = {
    "accuracyMode" => "PRECISION"
}
params.rosette_options = options
response = rosette_api.get_relationships(params)
puts JSON.pretty_generate(response)
