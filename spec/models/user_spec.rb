require 'rails_helper'

RSpec.describe User, :type => :model do
  describe '#password' do
    example '文字列を与えると、hashed_passwordは長さ60の文字列になる' do
      member = User.new
      member.password = 'webllis'
      expect(member.hashed_password).to be_kind_of(String)

      expect(member.hashed_password.size).to eq(60)
    end

    example 'nilを与えると、hashed_passwordはnilになる' do
      member = User.new(hashed_password: 'x')
      member.hashed_password = nil
      expect(member.hashed_password).to be_nil
    end
  end
end
