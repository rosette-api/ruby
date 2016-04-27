require_relative 'rosette_api_error'

# This class represents badRequest Rosette API errors.
class BadRequestError < RosetteAPIError
  def initialize(message)
    super 'badRequest', message
  end
end
