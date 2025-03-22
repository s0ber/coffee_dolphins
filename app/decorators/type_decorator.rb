class TypeDecorator < ApplicationDecorator

protected

  def confirm_remove_message
    "Remove type #{object.name}?"
  end
end
