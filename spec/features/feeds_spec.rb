require 'rails_helper'

feature 'フィードページ' do
  let(:user) { create(:user) }
  let(:editor) { create(:editor) }

  before do
    Capybara.app_host = 'http://www.example.com'
    create(:post, user: user, title: 'User Post')
    create(:post, user: editor, title: 'Editor Post')
  end

  scenario 'ログイン前、編集者の投稿を表示する' do
    visit root_path

    expect(page).to have_title('Webllis')

    expect(page).to have_content('Editor Post')
    expect(page).to have_content('Example Description')
    expect(page).to have_no_content('User Post')
  end

  scenario 'ログイン後、現在のユーザーのフィードを表示する' do
    login(user)
    visit root_path

    expect(page).to have_title('Webllis')

    user.feed.each do |item|
      expect(page).to have_content(item.title)
      expect(page).to have_content(item.description)
    end
  end
end
