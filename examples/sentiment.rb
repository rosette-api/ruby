# frozen_string_literal: true

require 'tempfile'
require 'rosette_api'

api_key, url = ARGV

rosette_api = if url
                RosetteAPI.new(api_key, url)
              else
                RosetteAPI.new(api_key)
              end

file = Tempfile.new(%w[foo .html])
sentiment_file_data = '<html><head><title>New Ghostbusters Film</title></head><body><p>Original Ghostbuster Dan Aykroyd, who also co-wrote the 1984 Ghostbusters film, couldn\'t be more pleased with the new all-female Ghostbusters cast, telling The Hollywood Reporter, "The Aykroyd family is delighted by this inheritance of the Ghostbusters torch by these most magnificent women in comedy."</p></body></html>'
file.write(sentiment_file_data)
file.close
begin
  params = DocumentParameters.new(file_path: file.path, language: 'eng')
  response = rosette_api.get_sentiment(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => e
  printf('Rosette API Error (%<status_code>s): %<message>s',
         status_code: e.status_code,
         message: e.message)
end
