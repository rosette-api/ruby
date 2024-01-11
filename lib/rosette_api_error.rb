# frozen_string_literal: true

# This class encapsulates all Rosette API server errors encountered during
# requests.
class RosetteAPIError < StandardError
  # Rosette API error's status code
  attr_accessor :status_code
  # Rosette API error's message
  attr_accessor :message

  def initialize(status_code, message) # :notnew:
    @status_code = status_code
    @message = message
  end
end
