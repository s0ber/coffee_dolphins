class ForkDecorator < ApplicationDecorator

  def add_bet_button
    h.content_tag(:span, 'Добавить ставку', class: 'small_button is-green')
  end

protected

  def confirm_remove_message
    "Удалить вилку \"#{object.title}\"?"
  end
end
