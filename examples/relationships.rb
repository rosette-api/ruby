# frozen_string_literal: true

require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

relationships_text_data = 'FLIR Systems is headquartered in Oregon and ' \
  'produces thermal imaging, night vision, and infrared cameras and sensor ' \
  'systems.  According to the SEC\'s order instituting a settled ' \
  'administrative proceeding, FLIR entered into a multi-million dollar ' \
  'contract to provide thermal binoculars to the Saudi government in ' \
  'November 2008.  Timms and Ramahi were the primary sales employees ' \
  'responsible for the contract, and also were involved in negotiations to ' \
  'sell FLIR\'s security cameras to the same government officials.  At the ' \
  'time, Timms was the head of FLIR\'s Middle East office in Dubai.'

begin
  params = DocumentParameters.new(content: relationships_text_data)
  response = rosette_api.get_relationships(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => rosette_api_error
  printf('Rosette API Error (%s): %s',
         rosette_api_error.status_code,
         rosette_api_error.message)
end
