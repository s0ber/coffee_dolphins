class BookmakerDecorator < ApplicationDecorator
  decorates_association :transactions

  def ammount_rub
    if object.ammount_rub > 0
      h.content_tag :b, "+#{object.ammount_rub} RUB", class: 'status is-green'
    elsif object.ammount_rub < 0
      h.content_tag :b, "#{object.ammount_rub} RUB", class: 'status is-red'
    end
  end

  def ammount
    "#{object.ammount} #{currency}"
  end

  def exchange_rate
    "#{object.exchange_rate} RUB"
  end

  def statistics_link(title = nil, options = {})
    if object.statistics_url
      h.link_to(title || bookmaker.statistics_url, bookmaker.statistics_url, rel: 'noreferrer', class: options[:class], data: options[:data])
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
