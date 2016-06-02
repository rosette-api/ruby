require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

entities_text_data = 'Bill Murray will appear in new Ghostbusters film: Dr. Peter Venkman was spotted filming a cameo in Boston this… http://dlvr.it/BnsFfS'
params = DocumentParameters.new(content: entities_text_data)
# to improve performance, and if you don't need the QID, set this option
# params.rosette_options = { linkEntities: false }
response = rosette_api.get_entities(params)
puts JSON.pretty_generate(response)
