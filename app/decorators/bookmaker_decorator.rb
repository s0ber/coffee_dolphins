class BookmakerDecorator < ApplicationDecorator
  decorates_association :transactions

  def ammount_rub
    "#{object.ammount_rub} RUB"
  end

  def ammount
    "#{object.ammount} #{currency}"
  end

  def exchange_rate
    "#{object.exchange_rate} RUB"
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
