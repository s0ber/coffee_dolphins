class BetDecorator < ApplicationDecorator
  decorates_association :bookmaker

  def ammount_rub
    "#{object.ammount_rub} RUB"
  end

  def prize
    "#{object.prize} RUB"
  end
end
