require 'rails_helper'

RSpec.describe Post do
  describe '値の正規化' do
    example 'url前後の空白を除去' do
      post = create(:post, url: ' http://example.com ')
      expect(post.url).to eq('http://example.com')
    end

    example 'urlに含まれる全角英数字記号を半角に変換' do
      post = create(:post, url: 'ｈｔｔｐ：／／ｅｘａｍｐｌｅ．ｃｏｍ')
      expect(post.url).to eq('http://example.com')
    end

    example 'url前後の全角スペースを除去' do
      post = create(:post, url: "\u{3000}http://example.com\u{3000}")
      expect(post.url).to eq('http://example.com')
    end

    example 'url途中のスペースを除去' do
      post = create(:post, url: "http://e x a m p l e.c　o　m")
      expect(post.url).to eq('http://example.com')
    end

    example 'title前後の全角スペースを除去' do
      post = create(:post, title: '　タイトル　')
      expect(post.title).to eq('タイトル')
    end

    example 'title前後の全角スペースを除去' do
      post = create(:post, title: 'タ　イ　ト　ル')
      expect(post.title).to eq('タ イ ト ル')
    end

    example 'description前後の全角スペースを除去' do
      post = create(:post, description: '　説　明　')
      expect(post.description).to eq('説 明')
    end

    example 'descriptionの途中の全角スペースを半角スペースに変換' do
      post = create(:post, description: '説　明')
      expect(post.description).to eq('説 明')
    end
  end

  describe 'バリデーション' do
    example '空白のurlは無効' do
      post = build(:post, url: '')
      expect(post).not_to be_valid
    end

    example '先頭が「ftp」のurlは無効' do
      post = build(:post, url: 'ftp://')
      expect(post).not_to be_valid
    end

    example '先頭の「http://」を省略したurlは無効' do
      post = build(:post, url: 'example.com')
      expect(post).not_to be_valid
    end

    example '先頭が「https」のurlは有効' do
      post = build(:post, url: 'https://example.com')
      expect(post).to be_valid
    end

    example '大文字を含むurlは有効' do
      post = build(:post, url: 'HTTP://example.com')
      expect(post).to be_valid
    end

    example '空白のtitleは無効' do
      post = build(:post, title: '')
      expect(post).not_to be_valid
    end

    example '50文字以上のtitleは無効' do
      post = build(:post, title: 'a' * 51)
      expect(post).not_to be_valid
    end

    example '1001文字以上のdescriptionは無効' do
      post = build(:post, description: 'a'  * 1001)
      expect(post).not_to be_valid
    end
  end
end
