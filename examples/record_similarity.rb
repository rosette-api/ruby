# frozen_string_literal: true

require 'rosette_api'

api_key, url = ARGV

analytics_api = if url
                  RosetteAPI.new(api_key, url)
                else
                  RosetteAPI.new(api_key)
                end

begin
  # Field names
  primary_name_field = 'primaryName'
  dob_field = 'dob'
  dob2_field = 'dob2'
  addr_field = 'addr'
  str_field = 'jobTitle'
  number_field = 'age'
  bool_field = 'isRetired'

  dob_hyphen = '1993-04-16'

  # Request fields definition
  fields = {
    primary_name_field => { type: 'rni_name', weight: 0.5 },
    dob_field => { type: 'rni_date', weight: 0.2 },
    dob2_field => { type: 'rni_date', weight: 0.1 },
    addr_field => { type: 'rni_address', weight: 0.5 },
    str_field => { type: 'rni_string', weight: 0.2 },
    number_field => { type: 'rni_number', weight: 0.4 },
    bool_field => { type: 'rni_boolean', weight: 0.05 }
  }

  # Request properties
  properties = {
    threshold: 0.7,
    includeExplainInfo: true
  }

  # Records payload. This shape mirrors the Java example's left/right lists.
  #
  # NOTE: The exact record field object schemas are API-specific. This example
  # uses descriptive hashes that are intended to serialize cleanly to JSON.
  records = {
    left: [
      {
        primary_name_field => {
          text: 'Ethan R',
          entityType: 'PERSON',
          language: 'eng',
          languageOfOrigin: 'eng',
          script: 'Latn'
        },
        dob_field => dob_hyphen,
        dob2_field => {
          date: '04161993',
          format: 'MMddyyyy'
        },
        addr_field => '123 Roadlane Ave',
        str_field => {
          data: 'software engineer'
        }
      },
      {
        primary_name_field => {
          text: 'Evan R'
        },
        dob_field => {
          date: dob_hyphen
        },
        number_field => {
          data: 47
        },
        bool_field => {
          data: false
        }
      }
    ],
    right: [
      {
        primary_name_field => {
          text: 'Seth R',
          language: 'eng'
        },
        dob_field => {
          date: dob_hyphen
        },
        str_field => {
          data: 'manager'
        },
        bool_field => {
          data: true
        }
      },
      {
        primary_name_field => 'Ivan R',
        dob_field => {
          date: dob_hyphen
        },
        dob2_field => {
          date: '1993/04/16'
        },
        addr_field => {
          houseNumber: '123',
          road: 'Roadlane Ave',
          cityDistrict: 'Alpha'
        },
        number_field => {
          data: 72
        },
        bool_field => {
          data: true
        }
      }
    ]
  }

  params = RecordSimilarityParameters.new(fields, records, properties)
  response = analytics_api.get_record_similarity(params)
  puts JSON.pretty_generate(response)
rescue RosetteAPIError => e
  printf('Rosette API Error (%<status_code>s): %<message>s',
         status_code: e.status_code,
         message: e.message)
end
