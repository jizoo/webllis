FactoryGirl.define do
  factory :comment do
    post { FactoryGirl.create(:post) }
    creator
    reader
    content "Content.\nContent."
    type 'sent'
    created_at Date.parse('2014-01-01')

    factory :invalid_comment do
      content { nil }
    end

    factory :reply do
      type 'replies'
      parent { FactoryGirl.create(:comment) }
    end
  end
end
