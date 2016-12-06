require 'tempfile'
require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end


file = Tempfile.new(%w(foo .html))
sentiment_file_data = "<html><head><title>New Ghostbusters Film</title></head><body><p>Original Ghostbuster Dan Aykroyd, who also co-wrote the 1984 Ghostbusters film, couldn’t be more pleased with the new all-female Ghostbusters cast, telling The Hollywood Reporter, “The Aykroyd family is delighted by this inheritance of the Ghostbusters torch by these most magnificent women in comedy.”</p></body></html>"
                      'Aykroyd, who also co-wrote the 1984 Ghostbusters film, couldn’t be more pleased with the new ' \
                      'all-female Ghostbusters cast, telling The Hollywood Reporter, The Aykroyd family is delighted ' \
                      'by this inheritance of the Ghostbusters torch by these most magnificent women in comedy ' \
                      '.</p></body></html>'
file.write(sentiment_file_data)
file.close
begin
    params = DocumentParameters.new(file_path: file.path, language: 'eng')
    response = rosette_api.get_sentiment(params)
    puts JSON.pretty_generate(response)
rescue RosetteAPIError => rosette_api_error
    printf("Rosette API Error (%s): %s", rosette_api_error.status_code, rosette_api_error.message)
end
