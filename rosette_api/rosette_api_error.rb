# This class encapsulates all Rosette API server errors encountered during
# requests.
class RosetteAPIError < StandardError
  attr_accessor :status_code, :message

  def initialize(status_code, message)
    @status_code = status_code
    @message = message
  end
end