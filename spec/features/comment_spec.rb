require 'rails_helper'

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
