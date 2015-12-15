class ForkDecorator < ApplicationDecorator
  decorates_association :bets

  def add_bet_button
    h.content_tag(:span, 'Добавить ставку', class: 'small_button is-green', data: {modal: h.new_bet_path(fork_id: object.id)})
  end

protected

  def confirm_remove_message
    "Удалить вилку \"#{object.title}\"?"
  end
end
