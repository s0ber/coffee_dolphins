class UserDecorator < ApplicationDecorator
  def edit_button
    if object.admin? and !h.current_user.admin?
      h.content_tag :span, h.fa_icon('pencil'), class: 'small_button is-icon is-disabled'
    else
      h.link_to h.fa_icon('pencil'),
        h.edit_user_path(object),
        class: 'small_button is-icon',
        remote: true,
        data: {role: 'editable_item-edit_button'}
    end
  end

  def remove_button
    if object.id == h.current_user.id || object.admin?
      h.content_tag :span, h.fa_icon('close'), class: 'small_button is-icon is-red is-disabled'
    else
      h.link_to h.fa_icon('close'),
        h.user_path(object),
        class: 'small_button is-icon is-red',
        remote: true,
        method: :delete,
        data: {role: 'item-remove_button', confirm: "Удалить пользователя #{object.email}?"}
    end
  end
end
