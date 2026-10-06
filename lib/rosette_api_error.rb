# frozen_string_literal: true

# This class encapsulates all API server errors encountered during
# requests.
class RosetteAPIError < StandardError
  # API error's status code
  attr_accessor :status_code
  # API error's message
  attr_accessor :message

  def initialize(status_code, message) # :notnew:
    @status_code = status_code
    @message = message
    super(message)
  end
end
