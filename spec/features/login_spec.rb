require 'rails_helper'

feature 'ユーザによるログイン' do
  let(:user) { create(:user) }
  let(:suspended_user) { create(:user, suspended: true) }

  before { Capybara.app_host = 'http://www.example.com' }

  scenario 'ログインする時、トップページに遷移する' do
    login(user)

    expect(page.current_path).to eq root_path
    expect(page).to have_content 'ログインしました。'
  end

  scenario 'ユーザが編集ページにアクセスし、ログインする時、編集ページに遷移する' do
    visit edit_user_path(user)
    login(user)

    expect(page.current_path).to eq edit_user_path(user)
    expect(page).to have_content 'ログインしました。'
  end

  scenario '誤ったパスワードでログインする時、「メールアドレスまたはパスワードが正しくありません。」と表示される' do
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'wrongpw'
    click_button 'ログイン'

    expect(page).to have_content 'ログイン'
    expect(page).to have_content 'メールアドレスまたはパスワードが正しくありません。'
  end

  scenario 'アカウント停止の状態でログインする時、「アカウントが停止されています。」と表示される' do
    login(suspended_user)

    expect(page).to have_content 'ログイン'
    expect(page).to have_content 'アカウントが停止されています。'
  end
end
