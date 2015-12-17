class BookmakerDecorator < ApplicationDecorator
  decorates_association :transactions

  def ammount_rub
    if object.ammount_rub > 0
      h.content_tag :b, "+#{object.ammount_rub} RUB", class: 'status is-green'
    elsif object.ammount_rub < 0
      h.content_tag :b, "#{object.ammount_rub} RUB", class: 'status is-red'
    else
      '0 RUB'
    end
  end

  def ammount
    if object.ammount == 0
      "0 #{currency}"
    else
      "#{object.ammount.floor(1)} #{currency}"
    end
  end

  def exchange_rate
    if object.exchange_rate == 0
      'Невозможно подсчитать, нет транзакций'
    else
      "#{object.exchange_rate.ceil(1)} RUB"
    end
  end

  def statistics_link(title = nil, options = {})
    if object.statistics_url
      h.link_to(title || bookmaker.statistics_url, bookmaker.statistics_url,
                rel: 'noreferrer',
                target: '_blank',
                class: options[:class],
                data: options[:data])
    end
  end

  def description
    h.auto_link(
      h.simple_format(h.html_escape(object.description), class: 'panel-text'),
      html: {target: '_blank', rel: 'noreferrer'}
    )
  end

  def currency
    Currency::LIST[object.currency]
  end

protected

  def confirm_remove_message
    "Удалить букмейкера \"#{object.title}\"?"
  end
end
