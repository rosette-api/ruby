require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

entities_linked_text_data = 'Last month director Paul Feig announced the movie will have an all-star female cast including Kristen Wiig, Melissa McCarthy, Leslie Jones and Kate McKinnon.'
params = DocumentParameters.new(content: entities_linked_text_data, genre: 'social-media')
response = rosette_api.get_entities(params, true)
puts JSON.pretty_generate(response)
