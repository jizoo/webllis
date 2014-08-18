FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "person#{n}" }
    sequence(:email) { |n| "person#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
    suspended false
    icon_image 'https://secure.gravatar.com/avatar?s=50'

    factory :administrator do
      admin true
    end

    factory :editor do
      editor true
    end
  end
end
