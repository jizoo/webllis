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

feature 'コメント一覧' do
  let(:user1) { create(:user, name: 'nakata') }
  let(:user2) { create(:user, name: 'nakamura') }
  let!(:comment) { create(:comment, creator: user1, reader: user2, created_at: 1.year.ago, content: 'コメントです。') }
  let!(:reply1) { create(:reply, creator: user2, parent: comment, created_at: 5.months.ago, content: '返信です。') }
  let!(:reply2) { create(:reply, creator: user1, parent: reply1, created_at: Time.current, content: '返信への返信です。') }

  before do
    Capybara.app_host = 'http://www.example.com'
    login(user1)
  end

  scenario 'コメントツリーの表示' do
    visit post_path(comment.post)
    expect(page).to have_css('h1', text: '投稿の詳細')
    expect(page).to have_css('h3', text: 'コメント')
    # expect(page).to have_css('h3 span.badge', text: 3)

    expect(page).to have_css('ul li p', text: 'コメントです。')
    expect(page).to have_css('ul li', text: comment.created_at.strftime('%Y/%m/%d %H:%M'))
    expect(page).to have_css('ul li a', text: 'nakata')
    expect(page).to have_css('ul li a', text: '削除')
    expect(page).to have_css('ul li a', text: '返信')

    expect(page).to have_css('ul li ul li p', text: '返信です。')
    expect(page).to have_css('ul li ul li', text: reply1.created_at.strftime('%m/%d %H:%M'))
    expect(page).to have_css('ul li ul li a', text: 'nakamura')
    # expect(page).not_to have_css('ul li ul li a', text: '削除')
    expect(page).to have_css('ul li ul li a', text: '返信')

    expect(page).to have_css('ul li ul li ul li p', text: '返信への返信です。')
    expect(page).to have_css('ul li ul li ul li', text: reply2.created_at.strftime('%H:%M:%S'))
    expect(page).to have_css('ul li ul li ul li a', text: 'nakata')
    expect(page).to have_css('ul li ul li ul li a', text: '削除')
    expect(page).to have_css('ul li ul li ul li a', text: '返信')
  end
end
