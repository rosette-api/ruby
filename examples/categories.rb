# frozen_string_literal: true

require 'rosette_api'

api_key, url = ARGV

rosette_api = if url
                RosetteAPI.new(api_key, url)
              else
                RosetteAPI.new(api_key)
              end

categories_text_data = 'If you are a fan of the British television series Downton Abbey and you are planning to be in New York anytime before April 2nd, there is a perfect stop for you while in town.'
begin
  params = DocumentParameters.new(content: categories_text_data)
  response = rosette_api.get_categories(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => e
  printf('Rosette API Error (%<status_code>s): %<message>s',
         status_code: e.status_code,
         message: e.message)
end
