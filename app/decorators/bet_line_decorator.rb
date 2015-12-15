class BetLineDecorator < ApplicationDecorator
  def performed_at
    h.l(object.performed_at, format: :long)
  end

  def add_fork_button
    h.content_tag :span, 'Добавить вилку', class: 'small_button is-green', data: {role: 'items_list-show_form bet_page-new_fork_form'}
  end

  def expected_profit
    profit = h.content_tag :b, "#{object.min_profit}—#{object.max_profit} RUB", class: 'status is-green'
    "#{profit} (#{expected_profit_percents})".html_safe
  end

  def expected_profit_percents
    "#{object.min_profit_percent}%—#{object.max_profit_percent}%"
  end

  protected

  def confirm_remove_message
    "Удалить линию ставок?"
  end
end
