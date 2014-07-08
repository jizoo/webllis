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
end
