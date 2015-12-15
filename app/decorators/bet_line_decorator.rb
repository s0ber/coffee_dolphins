class BetLineDecorator < ApplicationDecorator
  def performed_at
    h.l(object.performed_at, format: :long)
  end

  def add_fork_button
    h.content_tag :span, 'Добавить вилку', class: 'small_button is-green', data: {role: 'items_list-show_form bet_page-new_fork_form'}
  end

  protected

  def confirm_remove_message
    "Удалить линию ставок?"
  end
end
