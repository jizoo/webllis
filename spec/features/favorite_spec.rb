require 'rails_helper'

feature '投稿の詳細' do
  let(:user) { create(:user) }
  let(:other) { create(:user) }
  let!(:other_post1) { create(:post, user: other) }
  let!(:other_post2) { create(:post, user: other) }

  before do
    Capybara.app_host = 'http://www.example.com'
    login(user)
    user.add_favorite!(other_post2)
  end

  scenario '「お気に入りに追加」' do
    visit post_path(other_post1)

    click_button 'お気に入りに追加'
    expect(page).to have_xpath("//input[@value='お気に入りの解除']")
    expect(page.current_path).to eq post_path(other_post1)
  end

  scenario '「お気に入りの解除」' do
    visit post_path(other_post2)

    click_button 'お気に入りの解除'
    expect(page).to have_xpath("//input[@value='お気に入りに追加']")
    expect(page.current_path).to eq post_path(other_post2)
  end
end
