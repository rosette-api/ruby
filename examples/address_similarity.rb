# frozen_string_literal: true

require 'rosette_api'

api_key, url = ARGV

rosette_api = if url
                RosetteAPI.new(api_key, url)
              else
                RosetteAPI.new(api_key)
              end

begin
  address1 = AddressParameter.new(
    'house_number': '1600',
    'road': 'Pennsylvania Ave NW',
    'city': 'Washington',
    'state': 'DC',
    'post_code': '20500'
  )
  address2 = AddressParameter.new(
    'house_number': '160',
    'road': 'Pennsilvana Avenue',
    'city': 'Washington',
    'state': 'D.C.',
    'post_code': '20500'
  )
  params = AddressSimilarityParameters.new(address1, address2)
  response = rosette_api.get_address_similarity(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => e
  printf('Rosette API Error (%<status_code>s): %<message>s',
         status_code: e.status_code,
         message: e.message)
end
