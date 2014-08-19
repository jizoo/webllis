require 'rails_helper'

feature '投稿一覧' do
  let(:user) { create(:user) }
  let(:editor) { create(:editor) }

  before do
    Capybara.app_host = 'http://www.example.com'
    create(:post, user: user, title: 'User Title')
    create(:post, user: editor, title: 'Editor Title')
  end

  context '未ログインユーザがアクセスした場合' do
    scenario '編集者の投稿を表示' do
      visit root_path

      expect(page).to have_title('Webllis')

      # expect(page).to have_css('h1', text: '編集者の投稿')
      expect(page).to have_css('h3 a', text: 'Editor Title')
      expect(page).to have_css('p', text: 'Example Description')
      expect(page).to have_css('span', text: '2014/01/01')
      # TODO: タグの表示
      expect(page).to have_css('span a', text: 'person')
      expect(page).to have_no_content('User Title')
    end
  end

  context 'ログインユーザがアクセスした場合' do
    scenario 'ログインユーザのフィードが表示' do
      login(user)
      visit root_path

      expect(page).to have_title('Webllis')

      expect(page).to have_css('h1', text: 'フィード')
      expect(page).to have_css('span', text: '2014/01/01')
      # TODO: タグの表示
      expect(page).to have_css('span a', text: 'person')
      Post.from_users_followed_by(user).each do |post|
        expect(page).to have_css('h3 a', text: post.title)
        expect(page).to have_css('p', text: post.description)
      end
    end

    scenario 'ログインユーザの投稿が表示' do
      login(user)
      visit posted_posts_path

      expect(page).to have_title('Webllis | 自分の投稿')

      expect(page).to have_css('h1', text: '自分の投稿')
      expect(page).to have_css('h3 a', text: 'User Title')
      expect(page).to have_css('p', text: 'Example Description')
      expect(page).to have_css('span', text: '2014/01/01')
      # TODO: タグの表示
      expect(page).to have_css('a', text: '詳細')
      expect(page).to have_css('a', text: '編集')
      expect(page).to have_css('a', text: '削除')
      expect(page).not_to have_css('span a', text: 'person')
      expect(page).to have_no_content('Editor Title')
    end

    scenario 'お気に入りの投稿を表示' do
      login(user)
      visit favorite_posts_path

      expect(page).to have_title('Webllis | お気に入りの投稿')
      # TODO: お気に入りの投稿の表示
    end

    scenario '編集者の投稿を表示' do
      login(user)
      visit picked_posts_path

      expect(page).to have_title('Webllis | 編集者の投稿')

      expect(page).to have_css('h1', text: '編集者の投稿')
      expect(page).to have_css('h3 a', text: 'Editor Title')
      expect(page).to have_css('p', text: 'Example Description')
      expect(page).to have_css('span', text: '2014/01/01')
      # TODO: タグの表示
      expect(page).to have_css('span a', text: 'person')
      expect(page).to have_no_content('User Title')
    end
  end
end

feature '投稿の詳細' do
  let(:user) { create(:user) }
  let(:editor) { create(:editor) }
  let!(:user_post) { create(:post, user: user, title: 'User Title', ) }
  let!(:editor_post) { create(:post, user: editor, title: 'Editor Title', ) }

  before do
    Capybara.app_host = 'http://www.example.com'
  end

  context '未ログインユーザがアクセスした場合' do
    scenario '編集者の投稿の詳細の表示' do
      visit post_path(editor_post)

      expect(page).to have_title('Webllis | Editor Title')

      expect(page).to have_css('h1', text: '投稿の詳細')
      expect(page).to have_css('h3 a', text: 'Editor Title')
      expect(page).to have_css('p', text: 'Example Description')
      expect(page).to have_css('dl dd', text: '2014/01/01')
      # TODO: タグの表示
      expect(page).to have_css('dl a', text: 'person')
      expect(page).not_to have_css('h3', text: 'コメント')
    end
  end

  context 'ログインユーザがアクセスした場合' do
    scenario 'ログインユーザの投稿の詳細が表示' do
      login(user)
      visit post_path(user_post)

      expect(page).to have_title('Webllis | User Title')

      expect(page).to have_css('h1', text: '投稿の詳細')
      expect(page).to have_css('h3 a', text: 'User Title')
      expect(page).to have_css('p', text: 'Example Description')
      expect(page).to have_css('dl dd', text: '2014/01/01')
      # TODO: タグの表示
      expect(page).to have_css('dl a', text: 'person')
      expect(page).to have_css('h3', text: 'コメント')
    end
  end
end

feature '投稿する' do
  let(:user) { create(:user) }

  before do
    login(user)
    click_link '投稿する'
  end

  scenario 'ログインユーザが新しい投稿を追加する' do
    fill_in 'URL', with: 'http://webllis.com'
    fill_in 'タイトル', with: 'タイトル'
    fill_in '説明', with: '説明です。'
    click_button '投稿'

    user.reload
    expect(user.posts.size).to eq(1)
    expect(user.posts[0].url).to eq('http://webllis.com')
  end

  scenario 'ログインユーザが無効な値を入力する' do
    fill_in 'URL', with: 'webllis.com'
    fill_in 'タイトル', with: 'タイトル'
    fill_in '説明', with: '説明です。'
    click_button '投稿'

    # TODO: エラーの表示
  end
end
