require 'rails_helper'

RSpec.describe Post do
  describe 'テーブルの関係性' do
    it { should belong_to(:user) }
    it { should have_many(:favorites).dependent(:destroy) }
    it { should have_many(:favorited_users) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe '値の正規化' do
    describe 'url' do
      it '前後の半角スペースを除去' do
        post = create(:post, url: ' http://example.com ')
        expect(post.url).to eq('http://example.com')
      end

      it '前後の全角スペースを除去' do
        post = create(:post, url: '　http://example.com　')
        expect(post.url).to eq('http://example.com')
      end

      it '途中の半角スペースを除去' do
        post = create(:post, url: 'http://e x a m p l e.com')
        expect(post.url).to eq('http://example.com')
      end

      it '途中の全角スペースを除去' do
        post = create(:post, url: 'http://e　x　a　m　p　l　e.com')
        expect(post.url).to eq('http://example.com')
      end

      it '全角英数字記号を半角に変換' do
        post = create(:post, url: 'ｈｔｔｐ：／／ｅｘａｍｐｌｅ．ｃｏｍ')
        expect(post.url).to eq('http://example.com')
      end

      it '大文字を小文字に変換' do
        post = create(:post, url: 'HTTP://EXAMPLE.COM')
        expect(post.url).to eq('http://example.com')
      end
    end

    describe 'title' do
      it '前後の全角スペースを除去' do
        post = create(:post, title: '　タイトル　')
        expect(post.title).to eq('タイトル')
      end

      it '前後の半角スペースを除去' do
        post = create(:post, title: ' タイトル ')
        expect(post.title).to eq('タイトル')
      end

      it '途中の全角スペースを半角スペースに変換' do
        post = create(:post, title: 'タ　イ　ト　ル')
        expect(post.title).to eq('タ イ ト ル')
      end

      it '全角英数字記号を半角に変換' do
        post = create(:post, title: 'Ｔｉｔｌｅ')
        expect(post.title).to eq('Title')
      end
    end

    describe 'description' do
      it '前後の全角スペースを除去' do
        post = create(:post, description: '　説明　')
        expect(post.description).to eq('説明')
      end

      it '前後の半角スペースを除去' do
        post = create(:post, description: ' 説明 ')
        expect(post.description).to eq('説明')
      end

      it '途中の全角スペースを半角スペースに変換' do
        post = create(:post, description: '説　明')
        expect(post.description).to eq('説 明')
      end
    end
  end

  describe 'バリデーション' do
    before { create(:post) }

    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:title) }
    it { should ensure_length_of(:title).is_within(3..50) }
    it { should ensure_length_of(:description).is_within(0..1000) }

    describe 'url' do
      it '「http://example.com」なら有効' do
        post = build(:post, url: 'https://example.com')
        expect(post).to be_valid
      end

      it '先頭が「https」なら有効' do
        post = build(:post, url: 'https://example.com')
        expect(post).to be_valid
      end

      it '先頭が「ftp」なら無効' do
        post = build(:post, url: 'ftp://')
        expect(post).to be_invalid
      end

      it '先頭が「http://」を省略しているなら無効' do
        post = build(:post, url: 'example.com')
        expect(post).to be_invalid
      end
    end
  end
end
