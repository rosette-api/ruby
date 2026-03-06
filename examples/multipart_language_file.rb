# frozen_string_literal: true

require 'rosette_api'
require 'fileutils'

api_key, url = ARGV

analytics_api = if url
                  RosetteAPI.new(api_key, url)
                else
                  RosetteAPI.new(api_key)
                end

begin
  # Create a sample file to upload (so the example is runnable as-is).
  file_path = File.expand_path('sample.txt', __dir__)
  File.write(file_path, "Bonjour tout le monde.\n")

  params = DocumentParameters.new(file_path: file_path)
  response = analytics_api.get_language(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => e
  printf('Rosette API Error (%<status_code>s): %<message>s',
         status_code: e.status_code,
         message: e.message)
ensure
  FileUtils.rm_f(file_path)
end
