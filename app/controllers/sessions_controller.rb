class SessionsController < ApplicationController
  skip_before_action :authorize
  before_action :strict_logged_in_user, only: [ :new, :create ]

  def new
    @form = LoginForm.new
  end

  def create
    @form = LoginForm.new(params[:login_form])
    user = User.find_by(email_for_index: @form.email.downcase) if @form.email.present?
    if Authenticator.new(user).authenticate(@form.password)
      login(user, @form)
      redirect_back_or_root_after_login(user)
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードが正しくありません。'
      render action: 'new'
    end
  end

  def destroy
    logout
    flash[:info] = 'ログアウトしました。'
    redirect_to :root
  end

  private

  def strict_logged_in_user
    if logged_in?
      flash[:warning] = '既にログイン済です。'
      redirect_to :root
    end
  end
end
