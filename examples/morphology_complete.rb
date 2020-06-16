# frozen_string_literal: true

require 'rosette_api'

api_key, url = ARGV

rosette_api = if url
                RosetteAPI.new(api_key, url)
              else
                RosetteAPI.new(api_key)
              end

morphology_complete_data = 'The quick brown fox jumped over the lazy dog. 👍🏾 Yes he did. B)'
begin
  params = DocumentParameters.new(content: morphology_complete_data)
  response = rosette_api.get_morphology_complete(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => e
  printf('Rosette API Error (%<status_code>s): %<message>s',
         status_code: e.status_code,
         message: e.message)
end
