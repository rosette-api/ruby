require '../rosette_api'
require '../document_parameters'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

params = DocumentParameters.new
params.content_uri = 'http://www.onlocationvacations.com/2015/03/05/the-new-ghostbusters-movie-begins-filming-in-boston-in-june/'
response = rosette_api.get_categories(params)
puts JSON.pretty_generate(response)
