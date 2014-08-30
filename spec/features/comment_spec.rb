require 'rails_helper'

feature 'コメント一覧' do
  let(:user1) { create(:user, name: 'jizoo') }
  let(:user2) { create(:user, name: 'nakata') }
  let(:user3) { create(:user, name: 'ono') }
  let!(:comment_from_user1_to_user2) { create(:comment, creator: user1, reader: user2, content: '1.jからnへのコメント') }
  let!(:comment_from_user2_to_user3) { create(:comment, creator: user2, reader: user3, content: '2.nからoへのコメント') }
  let!(:comment_from_user3_to_user1) { create(:comment, creator: user3, reader: user1, content: '3.oからjへのコメント') }
  let!(:reply) { create(:reply, creator: user1, reader: user2, content: 'jからoへの返信') }
  let!(:reader_trashed_comment_from_user1_to_user2) { create(:comment, creator: user1, reader: user2, reader_trashed: true, content: '4.jからnへの読者によって捨てられたコメント') }
  let!(:reader_trashed_comment_from_user2_to_user3) { create(:comment, creator: user2, reader: user3, reader_trashed: true, content: '5.nからoへの読者によって捨てられたコメント') }
  let!(:reader_trashed_comment_from_user3_to_user1) { create(:comment, creator: user3, reader: user1, reader_trashed: true, content: '6.oからjへの読者によって捨てられたコメント') }
  let!(:creator_trashed_comment_from_user1_to_user2) { create(:comment, creator: user1, reader: user2, creator_trashed: true, content: '7.jからnへの作成者によって捨てられたコメント') }
  let!(:creator_trashed_comment_from_user2_to_user3) { create(:comment, creator: user2, reader: user3, creator_trashed: true, content: '8.nからoへの作成者によって捨てられたコメント') }
  let!(:creator_trashed_comment_from_user3_to_user1) { create(:comment, creator: user3, reader: user1, creator_trashed: true, content: '9.oからjへの作成者によって捨てられたコメント') }
  let!(:trashed_reply) { create(:reply, creator: user1, reader: user2, creator_trashed: true, content: 'jからoへの捨てられた返信') }

  before do
    Capybara.app_host = 'http://www.example.com'
  end

  context 'ログインユーザがアクセスした場合' do
    scenario 'ログインユーザが作成者または読者のコメントと返信を表示' do
      login(user1)
      visit comments_path

      expect(page).to have_title('Webllis | コメント')

      expect(page).to have_css('h1', text: 'コメント一覧')

      expect(page).to have_css('tr td a', text: 'jizoo')
      expect(page).not_to have_css('tr td a', text: 'nakata')
      expect(page).to have_css('tr td a', text: 'ono')

      expect(page).to have_css('tr td', text: 'コメント')
      expect(page).to have_css('tr td', text: '1.jからnへのコメント')
      expect(page).not_to have_css('tr td', text: '2.nからoへのコメント')
      expect(page).to have_css('tr td', text: '3.oからjへのコメント')
      # user2がtrashしたコメントのためuser1にはコメント一覧に表示される。
      expect(page).to have_css('tr td', text: '4.jからnへの読者によって')
      expect(page).not_to have_css('tr td', text: '5.nからoへの読者によって')
      expect(page).not_to have_css('tr td', text: '6.oからjへの読者によって')
      expect(page).not_to have_css('tr td', text: '7.jからnへの作成者によって')
      expect(page).not_to have_css('tr td', text: '8.nからoへの作成者によって')
      # user3がtrashしたコメントのためuser1にはコメント一覧に表示される。
      expect(page).to have_css('tr td', text: '9.oからjへの作成者によって')

      expect(page).to have_css('tr td', text: '返信')
      expect(page).to have_css('tr td', text: 'jからoへの返信')
      expect(page).not_to have_css('tr td', text: 'jからoへの捨てられた返信')

      expect(page).to have_css('tr td a', text: '返信')
      expect(page).to have_css('tr td a', text: 'ゴミ箱')
    end

    scenario 'ログインユーザが捨てたコメントと返信を表示' do
      login(user1)
      visit trashed_comments_path

      expect(page).to have_title('Webllis | ゴミ箱')

      expect(page).to have_css('h1', text: 'ゴミ箱')

      expect(page).to have_css('tr td a', text: 'jizoo')
      expect(page).not_to have_css('tr td a', text: 'nakata')
      expect(page).to have_css('tr td a', text: 'ono')

      expect(page).to have_css('tr td', text: 'コメント')
      expect(page).not_to have_css('tr td', text: '1.jからnへのコメント')
      expect(page).not_to have_css('tr td', text: '2.nからoへのコメント')
      expect(page).not_to have_css('tr td', text: '3.oからjへのコメント')
      expect(page).not_to have_css('tr td', text: '4.jからnへの読者によって')
      expect(page).not_to have_css('tr td', text: '5.nからoへの読者によって')
      expect(page).to have_css('tr td', text: '6.oからjへの読者によって')
      expect(page).to have_css('tr td', text: '7.jからnへの作成者によって')
      expect(page).not_to have_css('tr td', text: '8.nからoへの作成者によって')
      expect(page).not_to have_css('tr td', text: '9.oからjへの作成者によって')

      expect(page).to have_css('tr td', text: '返信')
      expect(page).not_to have_css('tr td', text: 'jからoへの返信')
      expect(page).to have_css('tr td', text: 'jからoへの捨てられた返信')

      expect(page).to have_css('tr td a', text: '復元')
      expect(page).to have_css('tr td a', text: '削除')
    end
  end
end
