require 'rails_helper'

describe Admin::UsersController, 'ログイン前' do
  # it_behaves_like 'a protected admin controller'
end

describe Admin::UsersController do
  let(:params_hash) { attributes_for(:user) }
  let(:administrator) { create(:administrator) }

  before do
    login(administrator)
    session[:last_access_time] = 1.second.ago
  end

  describe '#create' do
    it 'ユーザ一覧ページにリダイレクト' do
      # post :create, user: params_hash
      # expect(response).to redirect_to(admin_users_url)
    end

    it '例外ActionController::ParameterMissingが発生' do
      bypass_rescue
      expect { post :create }.
        to raise_error(ActionController::ParameterMissing)
    end
  end
end
