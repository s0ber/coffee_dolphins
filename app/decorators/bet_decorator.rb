class BetDecorator < ApplicationDecorator
  decorates_association :bookmaker

  def ammount_rub
    "#{object.ammount_rub} RUB"
  end

  def prize
    if object.fork.winning_bet_id == object.id
      add_sign(object.prize)
    else
      "#{object.prize} RUB"
    end
  end

  def result_tag
    if object.result == :pending
      h.content_tag(:b, 'Ожидает результата', class: 'status is-orange')
    elsif object.result == :bet_plus
      h.content_tag(:b, 'Ставка победила', class: 'status is-green')
    elsif object.result == :bet_minus
      h.content_tag(:b, 'Ставка проиграла', class: 'status is-red')
    end
  end

  def ammount
    if object.ammount
      h.content_tag(:span, "#{object.ammount} #{bookmaker.currency}")
    end
  end
end
