require 'rails_helper'

describe Authenticator do
  describe '#authenticate' do
    example '正しいパスワードならtrueを返す' do
      u = build(:user)
      expect(Authenticator.new(u).authenticate('password')).to be_truthy
    end

    example '誤ったパスワードならfalseを返す' do
      u = build(:user)
      expect(Authenticator.new(u).authenticate('wordpass')).to be_falsey
    end

    example 'パスワード未設定ならfalseを返す' do
      u = build(:user, password: nil)
      expect(Authenticator.new(u).authenticate(nil)).to be_falsey
    end

    example '停止フラグが立っていればfalseを返す' do
      u = build(:user, suspended: true)
      expect(Authenticator.new(u).authenticate('pasword')).to be_falsey
    end
  end
end
