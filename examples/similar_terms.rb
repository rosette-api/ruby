# frozen_string_literal: true
require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

similar_terms_data = "spy"
begin
  params = DocumentParameters.new(content: similar_terms_data)
  params.rosette_options = { "resultLanguages" => ["spa", "deu", "jpn"] }
  response = rosette_api.get_similar_terms(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => rosette_api_error
  printf('Rosette API Error (%s): %s', rosette_api_error.status_code, rosette_api_error.message)
end
