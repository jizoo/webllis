require 'rails_helper'

describe SessionsController do
  describe '#create' do
    let(:user) { create(:user) }
    let(:suspended_user) { create(:user, suspended: true) }

    it '「次回から自動でログインする」にチェックせずにログイン' do
      post :create, login_form: {
        email: user.email,
        password: user.password
      }

      expect(session[:user_id]).to eq(user.id)
      expect(response.cookies).not_to have_key('user_id')
      expect(response).to redirect_to(root_path)
    end

    it '「次回から自動でログインする」にチェックしてログイン' do
      post :create, login_form: {
        email: user.email,
        password: user.password,
        remember_me: '1'
      }

      expect(session).not_to have_key('user_id')
      expect(response.cookies['user_id']).to match(/[0-9a-f]{40}\z/)
      expect(response).to redirect_to(root_path)

      cookies = response.request.env['action_dispatch.cookies']
        .instance_variable_get(:@set_cookies)
      expect(cookies['user_id'][:expires]).to be > 19.years.from_now
    end

    it '誤ったパスワードでログイン' do
      post :create, login_form: {
        email: user.email,
        password: 'wrongpw'
      }

      expect(session[:user_id]).to be_nil
      expect(response).to render_template(:new)
    end

    it 'アカウント停止の状態でログイン' do
      post :create, login_form: {
        email: suspended_user.email,
        password: suspended_user.password
      }

      expect(session[:user_id]).to be_nil
      expect(response).to render_template(:new)
    end
  end

  describe '#destroy' do
    before { get :destroy }

    it 'ログアウト' do
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end
end
