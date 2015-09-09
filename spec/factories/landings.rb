FactoryGirl.define do
  factory :landing do
    title 'My test landing'
    slug 'test-slug'
    category_id 1
    position_id 1
    _status :draft
  end
end
