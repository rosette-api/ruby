class RosetteAPIError < StandardError
  attr_accessor :status_code, :message

  def initialize(status_code, message)
    @status_code = status_code
    @message = message
  end
end