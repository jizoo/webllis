FactoryGirl.define do
  factory :comment do
    post
    creator
    reader
    content "Content.\nContent."
    type 'sent'

    factory :invalid_comment do
      content { nil }
    end

    factory :reply do
      type 'replies'
    end
  end
end
