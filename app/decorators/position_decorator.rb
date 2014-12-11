class PositionDecorator < ApplicationDecorator
  decorates_association :notes

protected

  def confirm_remove_message
    "Удалить позицию #{object.title}?"
  end
end
