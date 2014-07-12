class Admin::SessionsController < Admin::Base
  skip_before_action :authorize

  def new
    if logged_in?
      redirect_to :admin_root
    else
      @form = Admin::LoginForm.new
      render action: 'new'
    end
  end

  def create
    @form = Admin::LoginForm.new(params[:admin_login_form])
    if @form.email.present?
      administrator = Administrator.find_by(email_for_index: @form.email.downcase)
    end
    if Admin::Authenticator.new(administrator).authenticate(@form.password)
      login administrator
      session[:last_access_time] = Time.current
      flash[:info] = 'ログインしました。'
      redirect_to :admin_root
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードが正しくありません。'
      render action: 'new'
    end
  end

  def destroy
    logout
    flash[:info] = 'ログアウトしました。'
    redirect_to :admin_root
  end
end
