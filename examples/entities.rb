# encoding: UTF-8
# frozen_string_literal: true

require 'rosette_api'

api_key, url = ARGV

if !url
  rosette_api = RosetteAPI.new(api_key)
else
  rosette_api = RosetteAPI.new(api_key, url)
end

entities_text_data = "The Securities and Exchange Commission today " \
  "announced the leadership of the agency’s trial unit.  Bridget Fitzpatrick " \
  "has been named Chief Litigation Counsel of the SEC and David Gottesman " \
  "will continue to serve as the agency’s Deputy Chief Litigation Counsel. " \
  "Since December 2016, Ms. Fitzpatrick and Mr. Gottesman have served as " \
  "Co-Acting Chief Litigation Counsel.  In that role, they were jointly " \
  "responsible for supervising the trial unit at the agency’s Washington " \
  "D.C. headquarters as well as coordinating with litigators in the SEC’s " \
  "11 regional offices around the country."
begin
    params = DocumentParameters.new(content: entities_text_data,
                                    genre: 'social-media')
    response = rosette_api.get_entities(params)
    puts JSON.pretty_generate(response)
rescue RosetteAPIError => rosette_api_error
    printf("Rosette API Error (%s): %s",\
           rosette_api_error.status_code,
           rosette_api_error.message)
end
