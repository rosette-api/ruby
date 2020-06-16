# frozen_string_literal: true

require 'rosette_api'

api_key, url = ARGV

rosette_api = if url
                RosetteAPI.new(api_key, url)
              else
                RosetteAPI.new(api_key)
              end

relationships_text_data = 'FLIR Systems is headquartered in Oregon and produces thermal imaging, night vision, and infrared cameras and sensor systems.  According to the SEC\'s order instituting a settled administrative proceeding, FLIR entered into a multi-million dollar contract to provide thermal binoculars to the Saudi government in November 2008.  Timms and Ramahi were the primary sales employees responsible for the contract, and also were involved in negotiations to sell FLIR\'s security cameras to the same government officials.  At the time, Timms was the head of FLIR\'s Middle East office in Dubai.'

begin
  params = DocumentParameters.new(content: relationships_text_data)
  response = rosette_api.get_relationships(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => e
  printf('Rosette API Error (%<status_code>s): %<message>s',
         status_code: e.status_code,
         message: e.message)
end
