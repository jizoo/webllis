FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    name 'jizoo'
    password 'pw'
    suspended false
  end
end
