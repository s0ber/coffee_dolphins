FactoryGirl.define do
  factory :money_load_transaction do
    ammount_rub "9.99"
    ammount "9.99"
    currency 1
    bookmaker nil
    performed_at  { Time.zone.now }
  end

end
