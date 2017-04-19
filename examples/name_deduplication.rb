require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

dedup_list = ['John Smith', 'Johnathon Smith', 'Fred Jones']
threshold = 0.75
names = dedup_list.map { |n| NameParameter.new(n) }
begin
  params = NameDeduplicationParameters.new(names, threshold)
  response = rosette_api.get_name_deduplication(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => rosette_api_error
  printf('Rosette API Error (%s): %s', rosette_api_error.status_code, rosette_api_error.message)
end
