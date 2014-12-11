class UserDecorator < ApplicationDecorator
  def edit_button
    if object.admin? and !h.current_user.admin?
      h.content_tag :span, h.fa_icon('pencil'), class: 'small_button is-icon is-disabled'
    else
      super
    end
  end

  def remove_button
    if object.id == h.current_user.id || object.admin?
      h.content_tag :span, h.fa_icon('close'), class: 'small_button is-icon is-red is-disabled'
    else
      super
    end
  end

protected

  def confirm_remove_message
    "Удалить пользователя #{object.email}?"
  end
end
