# frozen_string_literal: true

require 'rosette_api'

api_key, url = ARGV

rosette_api = if url
                RosetteAPI.new(api_key, url)
              else
                RosetteAPI.new(api_key)
              end

language_multilingual_data = 'On Thursday, as protesters gathered in Washington D.C., the United States Federal Communications Commission under Chairman Ajit Pai voted 3-2 to overturn a 2015 decision, commonly called Net Neutrality, that forbade Internet service providers (ISPs) such as Verizon, Comcast, and AT&T from blocking individual websites or charging websites or customers more for faster load times.  Quatre femmes ont été nommées au Conseil de rédaction de la loi du Qatar. Jeudi, le décret royal du Qatar a annoncé que 28 nouveaux membres ont été nommés pour le Conseil de la Choura du pays.  ذكرت مصادر أمنية يونانية، أن 9 موقوفين من منظمة \"د هـ ك ب ج\" الذين كانت قد أوقفتهم الشرطة اليونانية في وقت سابق كانوا يخططون لاغتيال الرئيس التركي رجب طيب أردوغان.'

begin
  params = DocumentParameters.new(content: language_multilingual_data)
  params.rosette_options = { 'multilingual' => 'true' }
  params.custom_headers = { 'X-RosetteAPI-App' => 'ruby-app' }
  response = rosette_api.get_language(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => e
  printf('Rosette API Error (%<status_code>s): %<message>s',
         status_code: e.status_code,
         message: e.message)
end
