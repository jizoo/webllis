require 'rails_helper'

RSpec.describe Comment do
  describe 'テーブルの関係性' do
    it { should belong_to(:post) }
    it { should belong_to(:creator).class_name('User') }
    it { should belong_to(:reader).class_name('User') }
    it { should belong_to(:root).class_name('Comment') }
    it { should belong_to(:parent).class_name('Comment') }
    it { should have_many(:children).class_name('Comment') }
  end

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

  describe '.unprocessed_by_creator_or_reader' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    context '作成者がユーザの場合' do
      it 'コメントを集めること' do
        comment = create(:comment, creator: user1)
        expect(Comment.unprocessed_by_creator_or_reader(user1)).to eq([comment])
      end

      it '返信を集めること' do
        reply = create(:reply, creator: user1)
        expect(Comment.unprocessed_by_creator_or_reader(user1)).to eq([reply])
      end
    end

    context '作成者が他のユーザの場合' do
      it 'コメントを集めないこと' do
        comment = create(:comment, creator: user2)
        expect(Comment.unprocessed_by_creator_or_reader(user1)).not_to eq([comment])
      end

      it '返信を集めないこと' do
        reply = create(:reply, creator: user2)
        expect(Comment.unprocessed_by_creator_or_reader(user1)).not_to eq([reply])
      end
    end

    context '読者がユーザの場合' do
      it 'コメントを集めること' do
        comment = create(:comment, reader: user1)
        expect(Comment.unprocessed_by_creator_or_reader(user1)).to eq([comment])
      end

      it '返信を集めること' do
        reply = create(:reply, creator: user1)
        expect(Comment.unprocessed_by_creator_or_reader(user1)).to eq([reply])
      end
    end

    context '読者が他のユーザの場合' do
      it 'コメントを集めないこと' do
        comment = create(:comment, reader: user2)
        expect(Comment.unprocessed_by_creator_or_reader(user1)).not_to eq([comment])
      end

      it '返信を集めないこと' do
        reply = create(:reply, reader: user2)
        expect(Comment.unprocessed_by_creator_or_reader(user1)).not_to eq([reply])
      end
    end
  end

  describe '.trashed_by_creator_or_reader' do

  end

  describe '.unread_by' do

  end
end
