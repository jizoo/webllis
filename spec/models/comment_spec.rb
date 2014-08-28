require 'rails_helper'

RSpec.describe Comment do
  describe '値の正規化' do
    describe 'content' do
      it '前後の半角スペースを除去' do
        comment = create(:comment, content: ' comment ')
        expect(comment.content).to eq('comment')
      end

      it '前後の全角スペースを除去' do
        comment = create(:comment, content: '　comment　')
        expect(comment.content).to eq('comment')
      end

      it '途中の全角スペースを半角に変換' do
        comment = create(:comment, content: 'reply　comment')
        expect(comment.content).to eq('reply comment')
      end

      it '含まれる全角英数字記号を半角に変換' do
        comment = create(:comment, content: 'ｃｏｍｍｅｎｔ')
        expect(comment.content).to eq('comment')
      end
    end
  end

  describe 'バリデーション' do
    before { create(:comment) }

    it { should validate_presence_of(:content) }
    it { should ensure_length_of(:content).is_within(0..400) }
  end
end
