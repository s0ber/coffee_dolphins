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
    if object.ammount_rub > 0
      h.content_tag :b, "+#{object.ammount} #{currency}", class: 'status is-green'
    elsif object.ammount < 0
      h.content_tag :b, "#{object.ammount} #{currency}", class: 'status is-red'
    else
      "#{object.ammount} #{currency}"
    end
  end

  def currency
    Currency::LIST[object.bookmaker.currency]
  end

  def performed_at
    h.l(object.performed_at, format: :long)
  end

  def kind
    case Transaction::KINDS.invert[object.kind]
    when :load
      'Депозит'
    when :bet
      fork = object.bet.fork
      h.link_to("Ставка (#{fork.title})", h.bet_line_path(fork.bet_line))
    end
  end

protected

  def confirm_remove_message
    "Удалить транзакцию #{object.id}?"
  end
end
