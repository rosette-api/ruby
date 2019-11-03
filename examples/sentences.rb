# frozen_string_literal: true

require 'rosette_api'

api_key, url = ARGV

rosette_api = if url
                RosetteAPI.new(api_key, url)
              else
                RosetteAPI.new(api_key)
              end

sentences_data = 'This land is your land. This land is my land, from ' \
  'California to the New York island; from the red wood forest to the Gulf ' \
  'Stream waters. This land was made for you and Me. As I was walking that ' \
  'ribbon of highway, I saw above me that endless skyway: I saw below me ' \
  'that golden valley: This land was made for you and me.'

begin
  params = DocumentParameters.new
  params.content = sentences_data
  response = rosette_api.get_sentences(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => e
  printf('Rosette API Error (%<status_code>s): %<message>s',
         status_code: e.status_code,
         message: e.message)
end
