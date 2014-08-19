require 'rails_helper'

feature '投稿一覧' do
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

    Post.from_users_followed_by(user).each do |post|
      expect(page).to have_content(post.title)
      expect(page).to have_content(post.description)
    end
  end

  scenario '自分の投稿を表示する' do
    login(user)
    visit posted_posts_path

    expect(page).to have_title('Webllis | 自分の投稿')

    expect(page).to have_content('User Post')
    expect(page).to have_content('Example Description')
    expect(page).to have_no_content('Editor Post')
  end

  scenario 'お気に入りの投稿を表示する' do
    login(user)
    visit favorite_posts_path

    expect(page).to have_title('Webllis | お気に入りの投稿')
    # TODO: お気に入りの投稿の表示
  end

  scenario '編集者の投稿を表示する' do
    login(user)
    visit picked_posts_path

    expect(page).to have_title('Webllis | 編集者の投稿')

    expect(page).to have_content('Editor Post')
    expect(page).to have_content('Example Description')
    expect(page).to have_no_content('User Post')
  end
end
