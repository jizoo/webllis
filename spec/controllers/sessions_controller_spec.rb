require 'rails_helper'

describe SessionsController do
  describe '#create' do
    let(:user) { create(:user) }
    let(:suspended_user) { create(:user, suspended: true) }

    example 'ログイン' do
      post :create, login_form: {
        email: user.email,
        password: user.password
      }

      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to(root_path)
    end

    example '誤ったパスワードでログイン' do
      post :create, login_form: {
        email: user.email,
        password: 'wrongpw'
      }

      expect(session[:user_id]).to be_nil
      expect(response).to render_template(:new)
    end

    example 'アカウント停止の状態でログイン' do
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

    example 'ログアウト' do
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end
end
