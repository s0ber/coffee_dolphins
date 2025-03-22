class ApiGroupDecorator < ApplicationDecorator
  decorates_association :endpoints

protected

  def confirm_remove_message
    "Remove #{object.title} API Group?"
  end
end
