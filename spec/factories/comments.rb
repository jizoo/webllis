FactoryGirl.define do
  factory :comment do
    post
    creator
    reader
    content 'Content'
    type 'sent'
  end
end
