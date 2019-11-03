# frozen_string_literal: true

require 'rosette_api'

api_key, url = ARGV

rosette_api = if url
                RosetteAPI.new(api_key, url)
              else
                RosetteAPI.new(api_key)
              end

translated_name_data = 'معمر محمد أبو منيار القذاف'
begin
  params = NameTranslationParameters.new(
    translated_name_data,
    'eng',
    target_script: 'Latn'
  )
  response = rosette_api.get_name_translation(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => rosette_api_error
  printf('Rosette API Error (%<status_code>s): %<message>s',
         status_code: rosette_api_error.status_code,
         message: rosette_api_error.message)
end
