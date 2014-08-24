class AuthenticationsController < ApplicationController
  skip_before_action :authorize, only: :create
  before_action :authentications, only: :index

  def index
  end

  def create
    if logged_in?
      apply_oauth_to(current_user)
      redirect_to :authentications
    elsif authentication.present? || apply_oauth_to(user)
      login(user)
      redirect_back_or_root_after_login(user)
    else
      session[:omniauth] = oauth.except('extra')
      redirect_to :signup
    end
  end

  def destroy
    @authentication = authentications.find(params[:id])
    @authentication.destroy
    flash[:success] = '認証が解除されました。'
    redirect_to :authentications
  end

  private

  def authentications
    @authentications = current_user.authentications
  end

  def user
    if authentication.present?
      authentication.user
    else
      User.new
    end
  end

  def authentication
    Authentication.find_by(provider: oauth[:provider], uid: oauth[:uid])
  end

  def apply_oauth_to(user)
    user.apply_oauth(oauth)
    user.save
    flash[:success] = '認証が成功しました。' if logged_in?
  end

  def oauth
    request.env['omniauth.auth']
  end
end
