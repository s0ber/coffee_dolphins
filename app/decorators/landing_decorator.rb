class LandingDecorator < ApplicationDecorator
  decorates_association :position

  def public_path
    h.public_landing_path(object.category.slug, object.slug)
  end

  def human_status
    h.content_tag :b, (object.draft? ? 'Черновик' : 'Опубликован')
  end

protected
  def confirm_remove_message
    "Удалить лендинг #{object.title}?"
  end
end
