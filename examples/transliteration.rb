require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

transliteration_content_data = 'Kareem Abdul Jabbar holds the records for most points in the NBA'
transliteration_target_language = 'eng'
transliteration_target_script = 'Latn'
transliteration_source_language = 'ara'
transliteration_source_script = 'Latn'
begin
  params = TransliterationParameters.new(transliteration_content_data,
                                         transliteration_target_language,
                                         transliteration_target_script,
                                         transliteration_source_language,
                                         transliteration_source_script)
  response = rosette_api.transliteration(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => rosette_api_error
  printf('Rosette API Error (%s): %s', rosette_api_error.status_code, rosette_api_error.message)
end
