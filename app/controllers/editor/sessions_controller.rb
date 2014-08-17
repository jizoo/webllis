class Editor::SessionsController < Editor::ApplicationController
  skip_before_action :authorize

  def new
    if logged_in?
      redirect_to :editor_root
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
      if user.editor?
        login user
        user.events.create!(type: 'logged_in')
        session[:last_access_time] = Time.current
        flash[:info] = '編集者としてログインしました。'
        redirect_to :editor_root
      elsif user.suspended?
        user.events.create!(type: 'rejected')
        flash.now[:warning] = 'アカウントが停止されています。'
        render action: 'new'
      else
        flash.now[:warning] = '編集者権限が与えられていません。'
        render action: 'new'
      end
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードが正しくありません。'
      render action: 'new'
    end
  end

  def destroy
    logout
    flash[:info] = 'ログアウトしました。'
    redirect_to :editor_root
  end
end
