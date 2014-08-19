require 'rails_helper'

RSpec.describe Post do
  describe '値の正規化' do
   # TODO:
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

    example '空白のtitleは無効' do
      post = build(:post, title: '')
      expect(post).not_to be_valid
    end

    example '1001文字以上のdescriptionは無効' do
      post = build(:post, description: 'a'  * 1001)
      expect(post).not_to be_valid
    end
  end
end
