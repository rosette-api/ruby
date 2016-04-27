require '../rosette_api/rosette_api'
require '../rosette_api/document_parameters'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

params = DocumentParameters.new(content: '北京大学生物系主任办公室内部会议')
response = rosette_api.get_tokens(params)
puts JSON.pretty_generate(response)