require 'rails_helper'

feature 'ユーザによるログイン' do
  let(:user) { create(:user) }
  before { Capybara.app_host = 'http://www.example.com' }

  scenario 'ユーザが編集ページにアクセスし、ログインする時、編集ページに遷移する' do
    visit edit_user_path(user)
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'

    expect(page.current_path).to eq edit_user_path(user)
  end
end
