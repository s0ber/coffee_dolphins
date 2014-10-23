class UserDecorator < ApplicationDecorator
  def edit_button
    h.link_to 'Редактировать',
      h.edit_user_path(object),
      class: 'small_button',
      remote: true,
      data: {role: 'edit_item_button'}
  end

  def remove_button
    if object.id == h.current_user.id || object.admin?
      h.content_tag :span, 'Удалить', class: 'small_button is-red is-disabled'
    else
      h.link_to 'Удалить',
        h.user_path(object),
        class: 'small_button is-red',
        remote: true,
        method: :delete,
        data: {role: 'remove_item_button', confirm: "Удалить пользователя #{object.email}?"}
    end
  end
end
