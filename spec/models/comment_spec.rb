require 'rails_helper'

RSpec.describe Comment do
  describe '値の正規化' do
    example 'content前後の空白を除去' do
      comment = create(:comment, content: ' comment ')
      expect(comment.content).to eq('comment')
    end

    example 'contentに含まれる全角英数字記号を半角に変換' do
      comment = create(:comment, content: 'ｃｏｍｍｅｎｔ')
      expect(comment.content).to eq('comment')
    end

    example 'content途中の全角スペースを半角に変換' do
      comment = create(:comment, content: "reply\u{3000}comment")
      expect(comment.content).to eq('reply comment')
    end

    example 'content前後の全角スペースを除去' do
      comment = create(:comment, content: "\u{3000}comment\u{3000}")
      expect(comment.content).to eq('comment')
    end
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
