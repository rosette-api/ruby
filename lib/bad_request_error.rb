# frozen_string_literal: true

require_relative 'rosette_api_error'

# This class represents Rosette API errors with badRequest status_code.
class BadRequestError < RosetteAPIError
  def initialize(message) #:notnew:
    super 'badRequest', message
  end
end
