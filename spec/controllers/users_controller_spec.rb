require 'rails_helper'

describe UsersController do
  let(:params_hash) { attributes_for(:user) }

  describe '#create' do
    example 'トップページにリダイレクト' do
      post :create, user: params_hash
      expect(response).to redirect_to(root_url)
    end

    example '例外ActionController::ParameterMissingが発生' do
      bypass_rescue
      expect { post :create }.
        to raise_error(ActionController::ParameterMissing)
    end
  end

  describe '#update' do
    let(:user) { create(:user) }

    before do
      session[:user_id] = user.id
    end

    example 'email属性を変更する' do
      params_hash.merge!(email: 'test@example.com')
      patch :update, id: user.id, user: params_hash
      user.reload
      expect(user.email).to eq('test@example.com')
    end

    example 'hashed_passwordの値は書き換え不可' do
      params_hash.delete(:password)
      params_hash.merge!(hashed_password: 'x')
      expect {
        patch :update, id: user.id, user: params_hash
      }.not_to change { user.hashed_password.to_s }
    end

    example '例外ActionController::ParameterMissingが発生' do
      bypass_rescue
      expect { patch :update, id: user.id }.
        to raise_error(ActionController::ParameterMissing)
    end
  end
end
