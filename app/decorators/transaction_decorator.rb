class TransactionDecorator < ApplicationDecorator
protected

  def confirm_remove_message
    "Удалить транзакцию #{object.id}?"
  end
end
