class AuthenticationsController < ApplicationController
  skip_before_action :authorize

  def index
    @authentications = current_user.authentications if current_user
  end

  def create
    omniauth = request.env['omniauth.auth']
    authentication = Authentication.find_by(provider: omniauth[:provider], uid: omniauth[:uid])
    if authentication
      login authentication.user
      authentication.user.events.create!(type: 'logged_in')
      flash[:success] = 'ログインしました。'
      redirect_back_or :root
    elsif current_user
      current_user.apply_omniauth(omniauth)
      current_user.apply_omniauth(omniauth).save
      flash[:success] = '認証が成功しました。'
      redirect_to :authentications
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        login(:user, user)
        flash[:success] = 'ログインしました。'
        redirect_back_or :root
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to :signup
      end
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:success] = '認証が解除されました。'
    redirect_to :authentications
  end
end
