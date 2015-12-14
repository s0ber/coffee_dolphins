module AStream
  class Response
    attr_reader :status, :body, :message

    def initialize(status: :ok, body: nil, message: nil)
      @status, @body, @message = status, body, message
    end
  end
end
