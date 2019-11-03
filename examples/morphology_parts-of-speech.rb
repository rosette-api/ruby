# frozen_string_literal: true

require 'rosette_api'

api_key, url = ARGV

rosette_api = if url
                RosetteAPI.new(api_key, url)
              else
                RosetteAPI.new(api_key)
              end

morphology_parts_of_speech_data =
  'The fact is that the geese just went back to get a rest and I\'m not ' \
  'banking on their return soon'
begin
  params = DocumentParameters.new(content: morphology_parts_of_speech_data)
  response = rosette_api.get_parts_of_speech(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => rosette_api_error
  printf('Rosette API Error (%<status_code>s): %<message>s',
         status_code: rosette_api_error.status_code,
         message: rosette_api_error.message)
end
