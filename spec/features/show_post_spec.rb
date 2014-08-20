require 'rails_helper'

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
