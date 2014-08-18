require 'rails_helper'

feature 'ユーザによるログアウト' do
  let(:user) { create(:user) }

  before do
    Capybara.app_host = 'http://www.example.com'
    login(user)
  end

  scenario 'ログアウトする' do
    click_link 'ログアウト'
    expect(page.current_path).to eq root_path
    expect(page).to have_content 'ログアウトしました。'
    expect(page).to have_no_link 'ログアウト'
  end
end
