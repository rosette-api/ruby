# frozen_string_literal: true

require 'rosette_api'

api_key, url = ARGV

rosette_api = if url
                RosetteAPI.new(api_key, url)
              else
                RosetteAPI.new(api_key)
              end

language_data = 'Por favor Señorita, says the man.'
begin
  params = DocumentParameters.new(content: language_data)
  params.custom_headers = { 'X-RosetteAPI-App' => 'ruby-app' }
  response = rosette_api.get_language(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => e
  printf('Rosette API Error (%<status_code>s): %<message>s',
         status_code: e.status_code,
         message: e.message)
end
