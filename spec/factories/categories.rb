FactoryGirl.define do
  factory :category do
    title 'Test title'
    description 'test description'
    sequence(:slug) { |n| "cat-slug-#{n}" }
    html_title 'Test html title'
    meta_description 'Test meta description'
  end
end
