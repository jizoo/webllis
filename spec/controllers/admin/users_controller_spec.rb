require 'rails_helper'

describe Admin::UsersController do
  let(:params_hash) { attributes_for(:user) }

  describe '#create' do
    example 'ユーザ一覧ページにリダイレクト' do
      post :create, user: params_hash
      expect(response).to redirect_to(admin_users_url)
    end

    example '例外ActionController::ParameterMissingが発生' do
      bypass_rescue
      expect { post :create }.
        to raise_error(ActionController::ParameterMissing)
    end
  end
end
