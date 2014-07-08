class SessionsController < Base
  def new
    if current_user
      redirect_to :root
    else
      @form = LoginForm.new
      render action: 'new'
    end
  end

  def create
    @form = LoginForm.new(params[:login_form])
    if @form.email.present?
      user = User.find_by(email_for_index: @form.email.downcase)
    end
    if Authenticator.new(user).authenticate(@form.password)
      session[:user_id] = user.id
      flash[:info] = 'ログインしました。'
      redirect_to :root
    else
      flash.now[:warning] = 'メールアドレスまたはパスワードが正しくありません。'
      render action: 'new'
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:info] = 'ログアウトしました。'
    redirect_to :root
  end
end
