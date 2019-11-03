# frozen_string_literal: true

require 'rosette_api'

api_key, url = ARGV

rosette_api = if url
                RosetteAPI.new(api_key, url)
              else
                RosetteAPI.new(api_key)
              end

name_dedupe_data = 'Alice Terry,Alice Thierry,Betty Grable,Betty Gable,' \
  'Norma Shearer,Norm Shearer,Brigitte Helm,Bridget Helem,Judy Holliday,' \
  'Julie Halliday'

threshold = 0.75
names = name_dedupe_data.split(',').map { |n| NameParameter.new(n) }
begin
  params = NameDeduplicationParameters.new(names, threshold)
  response = rosette_api.get_name_deduplication(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => e
  printf('Rosette API Error (%<status_code>s): %<message>s',
         status_code: e.status_code,
         message: e.message)
end
