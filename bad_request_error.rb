require_relative 'rosette_api_error'

class BadRequestError < RosetteAPIError
  def initialize(message)
    super 'badRequest', message
  end
end
