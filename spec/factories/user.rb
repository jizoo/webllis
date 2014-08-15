FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
    suspended false
    icon_image 'https://secure.gravatar.com/avatar?s=50'

    factory :administrator do
      admin true
    end
  end
end
