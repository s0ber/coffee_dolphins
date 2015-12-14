class BookmakerDecorator < ApplicationDecorator
  decorates_association :transactions

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
