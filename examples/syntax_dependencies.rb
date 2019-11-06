# frozen_string_literal: true

require 'rosette_api'

api_key, url = ARGV

rosette_api = if url
                RosetteAPI.new(api_key, url)
              else
                RosetteAPI.new(api_key)
              end

syntax_dependencies_data =
  'Yoshinori Ohsumi, a Japanese cell biologist, was awarded the Nobel Prize ' \
  'in Physiology or Medicine on Monday.'

begin
  params = DocumentParameters.new(content: syntax_dependencies_data)
  response = rosette_api.get_syntax_dependencies(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => e
  printf('Rosette API Error (%<status_code>s): %<message>s',
         status_code: e.status_code,
         message: e.message)
end
