require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

categories_url_data = 'http://www.onlocationvacations.com/2015/03/05/the-new-ghostbusters-movie-begins-filming-in-boston-in-june/'
params = DocumentParameters.new(content_uri: categories_url_data)
response = rosette_api.get_categories(params)
puts JSON.pretty_generate(response)
