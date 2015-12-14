FactoryGirl.define do
  factory :money_load_transaction do
    ammount "9.99"
    exchange_rate "9.99"
    currency 1
    bookmaker nil
    performed_at  { Time.zone.now }
  end

end
