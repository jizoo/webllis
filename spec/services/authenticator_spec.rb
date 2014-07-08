require 'rails_helper'

describe Authenticator do
  describe '#authenticate' do
    example '正しいパスワードならtrueを返す' do
      m = build(:user)
      expect(Authenticator.new(m).authenticate('password')).to be_truthy
    end

    example '誤ったパスワードならfalseを返す' do
      m = build(:user)
      expect(Authenticator.new(m).authenticate('xy')).to be_falsey
    end

    example 'パスワード未設定ならfalseを返す' do
      m = build(:user, password: nil)
      expect(Authenticator.new(m).authenticate(nil)).to be_falsey
    end

    example '停止フラグが立っていればfalseを返す' do
      m = build(:user, suspended: true)
      expect(Authenticator.new(m).authenticate('pw')).to be_falsey
    end
  end
end
