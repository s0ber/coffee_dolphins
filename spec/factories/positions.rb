FactoryGirl.define do
  factory :position do
    title 'My position'
    price 10.00
    profit 10.00
    apishops_position_id 1
    availability_level 3

    trait :favorite do
      liked true
    end
  end
end
