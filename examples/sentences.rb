# frozen_string_literal: true

require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
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
rescue RosetteAPIError => rosette_api_error
  printf('Rosette API Error (%<status_code>s): %<message>s',
         status_code: rosette_api_error.status_code,
         message: rosette_api_error.message)
end
