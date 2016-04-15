require '../rosette_api'
require '../parameters'

api_key, url = ARGV

if !url
    rosette_api = RosetteAPI.new(api_key)
else
    rosette_api = RosetteAPI.new(api_key, url)
end

params = Parameters.new
params.content = '北京大学生物系主任办公室内部会议'
response = rosette_api.get_han_readings(params)
puts JSON.pretty_generate(response)