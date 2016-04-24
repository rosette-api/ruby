require_relative 'rosette_api_error'

class BadRequestFormatError < RosetteAPIError
  def initialize(message)
    super 'badRequestFormat', message
  end
end
