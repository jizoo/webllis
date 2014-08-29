require 'rails_helper'

RSpec.describe UserMailer do
  describe '#password_reset' do
    let(:user) { create(:user, password_reset_token: 'token') }

    before do
      UserMailer.password_reset(user).deliver
    end

    it 'ユーザにパスワードリセットのURLを送信すること' do
      expect(open_last_email).to be_delivered_from 'from@example.com'
      expect(open_last_email).to be_delivered_to user.email
      expect(open_last_email).to have_subject 'Webllisのパスワード設定'
    end

    it 'bodyを表示すること' do
      expect(open_last_email).to have_body_text "こんにちは、#{user.name}さん。"
      expect(open_last_email).to have_body_text edit_password_reset_path(user.password_reset_token)
    end
  end
end
