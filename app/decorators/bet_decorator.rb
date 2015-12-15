class BetDecorator < ApplicationDecorator
  decorates_association :bookmaker

  def ammount_rub
    "#{object.ammount_rub} RUB"
  end

  def prize
    "#{object.prize} RUB"
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
      h.content_tag(:span, "#{object.ammount.ceil(1)} #{bookmaker.currency}")
    end
  end
end
