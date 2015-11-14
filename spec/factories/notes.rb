FactoryGirl.define do
  factory :note do
    title 'Note title'
    comment 'Note comment'

    trait :zebra do
      sequence(:title) { |n| n % 2 == 0 ? "Note Even" : "Note Odd" }
      sequence(:notable_id)
      notable_type 'position'
    end
  end
end

