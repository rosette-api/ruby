# frozen_string_literal: true

require_relative 'rosette_api_error'

# This class represents Rosette API errors with badRequestFormat status_code.
class BadRequestFormatError < RosetteAPIError
  def initialize(message) #:notnew:
    super 'badRequestFormat', message
  end
end
