require '../rosette_api'
require '../document_parameters'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

params = DocumentParameters.new
params.content = 'Last month director Paul Feig announced the movie will have an all-star female cast including ' \
                 'Kristen Wiig, Melissa McCarthy, Leslie Jones and Kate McKinnon.'
response = rosette_api.get_entities_linked(params)
puts JSON.pretty_generate(response)