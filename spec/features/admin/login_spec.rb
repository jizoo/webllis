require 'rails_helper'

feature '管理者によるログイン' do
  before { Capybara.app_host = 'http://www.example.com/admin' }

  scenario 'ログインページに「次回から自動でログインする」チェックボックスが表示されない' do
    visit login_path

    expect(page).to have_title('ログイン')
    expect(page).to have_no_content '次回から自動でログインする'
  end
end
