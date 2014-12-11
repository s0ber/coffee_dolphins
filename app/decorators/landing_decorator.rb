class LandingDecorator < ApplicationDecorator
  decorates_association :position

  def public_path
    h.public_landing_path(object.category.slug, object.slug)
  end

protected
  def confirm_remove_message
    "Удалить лендинг #{object.title}?"
  end
end
