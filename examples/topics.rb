# frozen_string_literal: true

require 'rosette_api'

api_key, url = ARGV

rosette_api = if url
                RosetteAPI.new(api_key, url)
              else
                RosetteAPI.new(api_key)
              end

topics_data =
  'Lily Collins is in talks to join Nicholas Hoult in Chernin Entertainment ' \
  "and Fox Searchlight's J.R.R. Tolkien biopic Tolkien. Anthony Boyle, known " \
  'for playing Scorpius Malfoy in the British play Harry Potter and the ' \
  'Cursed Child, also has signed on for the film centered on the famed ' \
  'author. In Tolkien, Hoult will play the author of the Hobbit and Lord of ' \
  'the Rings book series that were later adapted into two Hollywood ' \
  'trilogies from Peter Jackson. Dome Karukoski is directing the project.'
begin
  params = DocumentParameters.new(content: topics_data)
  response = rosette_api.get_topics(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => e
  printf('Rosette API Error (%<status_code>s): %<message>s',
         status_code: e.status_code,
         message: e.message)
end
