require '../lib/rosette_api'
require '../lib/document_parameters'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

params = DocumentParameters.new
params.content = 'This land is your land. This land is my land\nFrom California to the New York island;\nFrom the' \
                 ' wood forest to the Gulf Stream waters\n\nThis land was made for you and Me.\n\nAs I was walking' \
                 ' that ribbon of highway,\nI saw above me that endless skyway:\nI saw below me that' \
                 ' golden valley:\nThis land was made for you and me.'
response = rosette_api.get_sentences(params)
puts JSON.pretty_generate(response)