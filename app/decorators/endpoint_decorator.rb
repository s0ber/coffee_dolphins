class EndpointDecorator < ApplicationDecorator

  def request_method_humanized
    Endpoint::REQUEST_METHODS_INVERTED[model.request_method]
  end

protected

  def confirm_remove_message
    "Remove endpoint?"
  end
end
