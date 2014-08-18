FactoryGirl.define do
  factory :post do
    user
    sequence(:url) { |n| "http://example.com#{n}" }
    sequence(:title) { |n| "Example Title#{n}" }
    sequence(:description) { |n| "Example Description#{n}" }
    sequence(:image) { |n| "http://example.com/image#{n}.jpg" }
  end
end
