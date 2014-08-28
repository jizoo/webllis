require 'rails_helper'

describe UsersController, '未ログインユーザ' do
  # it_behaves_like 'a protected user controller'

  let(:params_hash) { attributes_for(:user) }

  describe 'POST #create' do
    it 'トップページにリダイレクト' do
      post :create, user: params_hash
      expect(response).to redirect_to(root_url)
    end

    it 'ログインすること' do
      post :create, user: params_hash
      expect(session[:user_id]).to be_truthy
    end

    it '例外ActionController::ParameterMissingが発生' do
      bypass_rescue
      expect { post :create }.
        to raise_error(ActionController::ParameterMissing)
    end
  end
end

describe UsersController, 'ログインユーザ' do
  let(:params_hash) { attributes_for(:user) }
  let(:user) { create(:user) }

  before do
    login(user)
    session[:last_access_time] = 1.second.ago
  end

  describe 'GET #index' do
    it '停止フラグがセットされたら強制的にログアウト' do
      user.update_column(:suspended, true)
      get :index
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_url)
    end

    it '@usersにユーザーを集めること' do
      #
    end
  end

  describe 'PATCH #update' do
    it 'email属性を変更すること' do
      params_hash.merge!(email: 'test@example.com')
      patch :update, id: user.id, user: params_hash
      user.reload
      expect(user.email).to eq('test@example.com')
    end

    it 'hashed_passwordの値は書き換え不可' do
      params_hash.delete(:password)
      params_hash.merge!(hashed_password: 'x')
      expect {
        patch :update, id: user.id, user: params_hash
      }.not_to change { user.hashed_password.to_s }
    end

    it '例外ActionController::ParameterMissingが発生' do
      bypass_rescue
      expect { patch :update, id: user.id }.
        to raise_error(ActionController::ParameterMissing)
    end
  end
end
