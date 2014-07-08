FactoryGirl.define do
  factory :user do
    name 'jizoo'
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
    suspended false
  end
end
