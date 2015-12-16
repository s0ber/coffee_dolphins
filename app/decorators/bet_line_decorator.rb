class BetLineDecorator < ApplicationDecorator
  def ammount_rub
    if object.ammount_rub > 0
      h.content_tag :b, "-#{object.ammount_rub} RUB", class: 'status is-red'
    end
  end

  def performed_at
    h.l(object.performed_at, format: :long)
  end

  def add_fork_button
    h.content_tag :span, 'Добавить вилку', class: 'small_button is-green', data: {role: 'items_list-show_form bet_page-new_fork_form'}
  end

  def expected_profit
    profit = h.content_tag :b, "+#{object.min_profit}—#{object.max_profit} RUB", class: 'status is-green'
    "#{profit} (#{expected_profit_percents})".html_safe
  end

  def profit
    if object.profit > 0
      h.content_tag :b, "#{object.profit} RUB", class: 'status is-green'
    elsif object.profit < 0
      h.content_tag :b, "#{object.profit} RUB", class: 'status is-red'
    else
      "#{object.profit} RUB"
    end
  end

  def expected_profit_percents
    "#{object.min_profit_percent}%—#{object.max_profit_percent}%"
  end

  def actual_profit
    "#{profit} (#{object.profit_percent}%)".html_safe
  end

  def prize
    h.content_tag :b, "+#{object.ammount_rub + object.prize} RUB", class: 'status is-green'
  end

  protected

  def confirm_remove_message
    "Удалить линию ставок?"
  end
end
