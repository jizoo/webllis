require 'rails_helper'

feature '管理者によるユーザ管理' do
  let(:administrator) { create(:administrator) }
  let!(:user) { create(:user) }

  before do
    Capybara.app_host = 'http://www.example.com/admin'
    login(administrator)
  end

  pending '管理者がユーザを追加する' do
    first('div.container').click_link 'ユーザ管理'
    click_link '新規登録'

    fill_in 'ユーザ名', with: 'test'
    fill_in 'メールアドレス', with: 'test@example.jp'
    fill_in 'パスワード', with: 'testpw'
    fill_in 'パスワード（確認）', with: 'testpw'

    click_button '登録'

    new_user = User.order(:id).last
    expect(new_user.email).to eq('test@example.jp')
    expect(new_user.name).to eq('test')
    expect(new_user.hashed_password).to be_present
  end

  scenario '管理者がユーザのユーザ名、メールアドレス、アカウント停止を更新する' do
    first('div.container').click_link 'ユーザ管理'
    page.all('tr')[1].click_link '編集'

    fill_in 'ユーザ名', with: 'test'
    fill_in 'メールアドレス', with: 'test@example.jp'
    check 'アカウント停止'

    click_button '更新'

    user.reload
    expect(user.email).to eq('test@example.jp')
    expect(user.name).to eq('test')
    expect(user.suspended).to be_truthy
  end
end
