require 'rails_helper'

RSpec.describe Comment do
  describe '値の正規化' do
    # TODO
  end

  describe 'バリデーション' do
    example '空白のcontentは無効' do
      comment = build(:comment, content: '')
      expect(comment).not_to be_valid
    end

    example '401文字以上のcontentは無効' do
      comment = build(:comment, content: 'a'  * 401)
      expect(comment).not_to be_valid
    end
  end
end
