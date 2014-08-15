require 'rails_helper'

describe Admin::StaticPagesController, 'ログイン後' do
  let(:administrator) { create(:administrator) }

  before do
    login(administrator)
    session[:last_access_time] = 1.second.ago
  end

  describe '#home' do
    example '通常はstatic_pages/home/dashboardを表示' do
      get :home
      expect(response).to render_template('admin/static_pages/dashboard')
    end

    example '停止フラグがセットされたら強制的にログアウト' do
      administrator.update_column(:suspended, true)
      get :home
      expect(cookies[:remember_token]).to be_nil
      expect(response).to redirect_to(root_url)
    end

    example 'セッションタイムアウト' do
      session[:last_access_time] =
        Admin::Base::TIMEOUT.ago.advance(seconds: -1)
      get :home
      expect(cookies[:remember_token]).to be_nil
      expect(response).to redirect_to(admin_login_url)
    end
  end
end
