class TransactionDecorator < ApplicationDecorator
  def ammount_rub
    if object.ammount_rub > 0
      h.content_tag :b, "+#{object.ammount_rub} RUB", class: 'status is-green'
    elsif object.ammount_rub < 0
      h.content_tag :b, "#{object.ammount_rub} RUB", class: 'status is-red'
    else
      "#{object.ammount_rub} RUB"
    end
  end

  def ammount
    "#{transaction.ammount} #{currency}"
  end

  def currency
    Currency::LIST[object.bookmaker.currency]
  end

  def performed_at
    h.l(object.performed_at, format: :long)
  end

  def kind
    Transaction::KINDS[object.kind]
  end

protected

  def confirm_remove_message
    "Удалить транзакцию #{object.id}?"
  end
end
