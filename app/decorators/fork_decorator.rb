class ForkDecorator < ApplicationDecorator
  decorates_association :bets

  def add_bet_button
    h.content_tag(:span, 'Добавить ставку', class: 'small_button is-green', data: {modal: h.new_bet_path(fork_id: object.id)})
  end

  def select_winner_button
    h.content_tag(:span, h.fa_icon('dollar'), class: 'small_button is-icon is-green', data: {modal: h.select_winner_fork_path(id: object.id)})
  end

  def status_tag
    if object.status == :pending
      h.content_tag(:b, 'ожидание результата', class: 'status is-orange')
    else
      h.content_tag(:b, 'ставки сыграны', class: 'status is-green')
    end
  end

  def bets_list
    object.bets.map { |bet| ["Исход: #{bet.outcome} (#{bet.bookmaker.title})", bet.id] }
  end

protected

  def confirm_remove_message
    "Удалить вилку \"#{object.title}\"?"
  end
end
