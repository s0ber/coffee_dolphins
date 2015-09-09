FactoryGirl.define do
  factory :user do
    email 'sergey@gmail.com'
    password 'test_password'
    full_name 'Sergey Shishkalov'
    gender true
  end
end
