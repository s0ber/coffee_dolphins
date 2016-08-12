class ResourceDecorator < ApplicationDecorator

protected

  def confirm_remove_message
    "Remove resource #{object.name}?"
  end
end
