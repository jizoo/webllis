class SessionsController < Base
  skip_before_action :authorize

  def new
    if logged_in?
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
      if user.suspended?
        user.events.create!(type: 'rejected')
        flash.now[:warning] = 'アカウントが停止されています。'
        render action: 'new'
      else
        login user
        user.events.create!(type: 'logged_in')
        flash[:info] = 'ログインしました。'
        redirect_to :root
      end
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
end
