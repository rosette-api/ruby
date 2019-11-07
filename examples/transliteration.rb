# frozen_string_literal: true

require 'rosette_api'

api_key, url = ARGV

rosette_api = if url
                RosetteAPI.new(api_key, url)
              else
                RosetteAPI.new(api_key)
              end

transliteration_content_data = 'ana r2ye7 el gam3a el sa3a 3 el 3asr'

begin
  params = DocumentParameters.new
  params.content = transliteration_content_data
  response = rosette_api.get_transliteration(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => e
  printf('Rosette API Error (%<status_code>s): %<message>s',
         status_code: e.status_code,
         message: e.message)
end
