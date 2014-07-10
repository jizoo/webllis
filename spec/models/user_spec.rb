require 'rails_helper'

RSpec.describe User do
  describe '#password' do
    example '文字列を与えると、hashed_passwordは長さ60の文字列になる' do
      user = User.new
      user.password = 'webllis'
      expect(user.hashed_password).to be_kind_of(String)

      expect(user.hashed_password.size).to eq(60)
    end

    example 'nilを与えると、hashed_passwordはnilになる' do
      user = User.new(hashed_password: 'x')
      user.hashed_password = nil
      expect(user.hashed_password).to be_nil
    end
  end

  describe '値の正規化' do
    example 'email前後の空白を除去' do
      user = create(:user, email: ' test@example.com ')
      expect(user.email).to eq('test@example.com')
    end

    example 'emailに含まれる全角英数字記号を半角に変換' do
      user = create(:user, email: 'ｔｅｓｔ＠ｅｘａｍｐｌｅ．ｃｏｍ')
      expect(user.email).to eq('test@example.com')
    end

    example 'email前後の全角スペースを除去' do
      user = create(:user, email: "\u{3000}test@example.com\u{3000}")
      expect(user.email).to eq('test@example.com')
    end
  end

  describe 'バリデーション' do
    example '@を2個含むemailは無効' do
      user = build(:user, email: 'test@@example.com')
      expect(user).not_to be_valid
    end

    example '記号を含むnameは無効' do
      user = build(:user, name: 'test-test')
      expect(user).not_to be_valid
    end

    example '大文字を含むnameは有効' do
      user = build(:user, name: 'Test')
      expect(user).to be_valid
    end

    example 'アンダースコアを含むnameは有効' do
      user = build(:user, name: 'test1')
      expect(user).to be_valid
    end

    example 'アンダースコアを含むnameは有効' do
      user = build(:user, name: 'test_test')
      expect(user).to be_valid
    end

    example '他のユーザのメールアドレスと重複したemailは無効' do
      user1 = create(:user)
      user2 = build(:user, email: user1.email)
      expect(user2).not_to be_valid
    end

    example 'password_confirmationと一致しないpasswordは無効' do
      user = build(:user, password_confirmation: 'mismatch')
      expect(user).not_to be_valid
    end
  end

  describe '#remember_token' do
    example 'remember_tokenが有効である' do
      user = create(:user) }
      expect(user.remember_token).not_to be_nil
    end
  end
end
