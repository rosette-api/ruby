require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

morphology_complete_data = "The quick brown fox jumped over the lazy dog. Yes he did."
begin
    params = DocumentParameters.new(content: morphology_complete_data)
    response = rosette_api.get_morphology_complete(params)
    puts JSON.pretty_generate(response)
rescue RosetteAPIError => rosette_api_error
    printf("Rosette API Error (%s): %s", rosette_api_error.status_code, rosette_api_error.message)
end
