class BookmakerDecorator < ApplicationDecorator

  def currency
    Currency::LIST[object.currency]
  end

protected

  def confirm_remove_message
    "Удалить букмейкера \"#{object.title}\"?"
  end
end
