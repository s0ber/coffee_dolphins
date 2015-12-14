class TransactionDecorator < ApplicationDecorator

  def ammount_rub
    "#{object.ammount_rub} RUB"
  end

  def ammount
    "#{transaction.ammount} #{bookmaker.currency}"
  end

  def kind
    Transaction::KINDS[object.kind]
  end

protected

  def confirm_remove_message
    "Удалить транзакцию #{object.id}?"
  end
end
