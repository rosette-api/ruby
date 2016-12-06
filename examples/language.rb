require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

language_data = "Por favor Señorita, says the man."
begin
    params = DocumentParameters.new(content: language_data)
    params.custom_headers = { 'X-RosetteAPI-App'=> 'ruby-app'}
    response = rosette_api.get_language(params)
    puts JSON.pretty_generate(response)
rescue RosetteAPIError => rosette_api_error
    printf("Rosette API Error (%s): %s", rosette_api_error.status_code, rosette_api_error.message)
end
