FactoryGirl.define do
  factory :user do
    email 'sergey@gmail.com'
    password 'test_password'
    full_name 'Sergey Shishkalov'
    gender true

    trait :admin do
      full_name 'Admin User'
      email 'coffeedolphins@gmail.com'
    end

    trait :moder do
      full_name 'Moder User'
      email 'ritose4ke@gmail.com'
      gender false
    end
  end
end
