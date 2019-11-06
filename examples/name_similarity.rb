# frozen_string_literal: true

require 'rosette_api'

api_key, url = ARGV

rosette_api = if url
                RosetteAPI.new(api_key, url)
              else
                RosetteAPI.new(api_key)
              end

matched_name_data1 = 'Michael Jackson'
matched_name_data2 = '迈克尔·杰克逊'
begin
  name1 = NameParameter.new(
    matched_name_data1,
    entity_type: 'PERSON',
    language: 'eng'
  )
  params = NameSimilarityParameters.new(name1, matched_name_data2)
  response = rosette_api.get_name_similarity(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => e
  printf('Rosette API Error (%<status_code>s): %<message>s',
         status_code: e.status_code,
         message: e.message)
end
