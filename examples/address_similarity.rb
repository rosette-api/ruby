require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

begin
  address1 = AddressParameter.new(
     'houseNumber': '1600',
     'road': 'Pennsylvania Ave NW',
     'city': 'Washington',
     'state': 'DC',
     'postCode': '20500'
  )
  address2 = AddressParameter.new(
     'houseNumber': '160',
     'road': 'Pennsilvana Avenue',
     'city': 'Washington',
     'state': 'D.C.',
     'postCode': '20500'
  )
  params = AddressSimilarityParameters.new(address1, address2)
  response = rosette_api.get_address_similarity(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => rosette_api_error
  printf('Rosette API Error (%s): %s', rosette_api_error.status_code, rosette_api_error.message)
end
