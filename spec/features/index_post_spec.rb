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
        expect(page).not_to have_css('h3 a', text: 'User Title')
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

    context '検索ワードがUser Titleの場合' do
      scenario '検索フォームから検索した投稿を表示' do
        login(user)
        find('#search_title').set('User Title')
        click_button '検索'

        expect(page).to have_title('Webllis | User Titleの検索結果')

        expect(page).to have_css('h1', text: 'User Titleの検索結果')
        expect(page).to have_css('h3 a', text: 'User Title')
        expect(page).to have_css('p', text: 'Example Description')
        expect(page).to have_css('span', text: '2014/01/01')
        # TODO: タグの表示
        expect(page).to have_css('span a', text: 'person')
        expect(page).not_to have_css('h3 a', text: 'Editor Title')
      end
    end

    context '検索ワードが空の場合' do
      scenario '検索フォームから検索した投稿を表示' do
        login(user)
        find('#search_title').set('')
        click_button '検索'

        expect(page).to have_title('Webllis')

        expect(page).to have_css('h1', text: '検索ワードが入力されていません。')
        expect(page).not_to have_css('h3 a', text: 'User Title')
        expect(page).not_to have_css('h3 a', text: 'Editor Title')
      end
    end

    scenario 'タグで検索した投稿を表示' do
      #TODO
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
      expect(page).not_to have_css('h3 a', text: 'Editor Title')
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
      expect(page).not_to have_css('h3 a', text: 'User Title')
    end
  end
end
