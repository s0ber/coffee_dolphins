module AStream
  class Response
    attr_reader :status, :body

    def initialize(status: , body: nil)
      @status, @body = status, body
    end
  end
end
