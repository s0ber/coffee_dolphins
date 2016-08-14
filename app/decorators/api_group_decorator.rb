class ApiGroupDecorator < ApplicationDecorator

protected

  def confirm_remove_message
    "Remove #{object.title} API Group?"
  end
end
