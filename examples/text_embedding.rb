require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

embeddings_data = 'Cambridge, Massachusetts'
params = DocumentParameters.new(content: embeddings_data, genre: 'social-media')
response = rosette_api.get_text_embedding(params)
puts JSON.pretty_generate(response)
