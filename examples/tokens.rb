require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

tokens_data = "北京大学生物系主任办公室内部会议"
params = DocumentParameters.new(content: tokens_data)
response = rosette_api.get_tokens(params)
puts JSON.pretty_generate(response)