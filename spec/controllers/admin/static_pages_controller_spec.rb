require 'rails_helper'

describe Admin::StaticPagesController, 'ログイン前' do
  let(:user) { create(:user) }

  describe 'IPアドレスによるアクセス制限' do
    before do
      Rails.application.config.webllis[:restrict_ip_addresses] = true
    end

    example '許可' do
      AllowedSource.create!(namespace: 'admin', ip_address: '0.0.0.0')
      get :home
      expect(response).to render_template('admin/static_pages/home')
    end

    example '拒否' do
      AllowedSource.create!(namespace: 'admin', ip_address: '192.168.0.*')
      get :home
      expect(response).to render_template('errors/forbidden')
    end
  end
end

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
        Admin::ApplicationController::TIMEOUT.ago.advance(seconds: -1)
      get :home
      expect(cookies[:remember_token]).to be_nil
      expect(response).to redirect_to(admin_login_url)
    end
  end
end
