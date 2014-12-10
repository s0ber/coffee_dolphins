class LandingDecorator < ApplicationDecorator
  decorates_association :position

protected
  def confirm_remove_message
    "Удалить лендинг #{object.title}?"
  end
end
