class BetLineDecorator < ApplicationDecorator
  def bets_ammount_rub
    if object.bets_ammount_rub > 0
      h.content_tag :b, "-#{object.bets_ammount_rub} RUB", class: 'status is-red'
    else
      "#{object.bets_ammount_rub} RUB"
    end
  end

  def performed_at
    h.l(object.performed_at, format: :long)
  end

  def add_fork_button
    h.content_tag :span, 'Добавить вилку', class: 'small_button is-green', data: {role: 'items_list-show_form bet_page-new_fork_form'}
  end

  def expected_profit
    "#{min_profit} – #{max_profit} RUB (#{expected_profit_percents})".html_safe
  end

  def min_profit
    add_sign(object.min_profit)
  end

  def max_profit
    add_sign(object.max_profit)
  end

  def profit
    add_sign(object.profit)
  end

  def expected_profit_percents
    "#{object.min_profit_percent}%—#{object.max_profit_percent}%"
  end

  def actual_profit
    "#{profit} (#{object.profit_percent}%)".html_safe
  end

  protected

  def confirm_remove_message
    "Удалить линию ставок?"
  end
end
