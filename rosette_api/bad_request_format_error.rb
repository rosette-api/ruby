require_relative 'rosette_api_error'

# This class represents the badRequestFormat Rosette API errors.
class BadRequestFormatError < RosetteAPIError
  def initialize(message)
    super 'badRequestFormat', message
  end
end
