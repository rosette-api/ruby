require '../rosette_api'
require '../parameters'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

params = Parameters.new
params.content =  'Bill Murray will appear in new Ghostbusters film: Dr. Peter Venkman was spotted filming a cameo ' \
                  'in Boston this… http://dlvr.it/BnsFfS'
response = rosette_api.get_entities(params)
puts JSON.pretty_generate(response)
