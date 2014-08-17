class PasswordResetsController < ApplicationController
  skip_before_action :authorize

  def new
    @reset_password_form = ResetPasswordForm.new
  end

  def edit
    @user = User.find_by!(password_reset_token: params[:id])
    @reset_password_form =
      ResetPasswordForm.new(object: @user)
  end

  def create
    @reset_password_form = ResetPasswordForm.new(user_params)
    if @reset_password_form.email.present?
      user = User.find_by(email_for_index: @reset_password_form.email.downcase)
    end
    if user.present?
      user.send_password_reset
      flash[:success] = 'パスワード再設定メールを送信しました。'
      redirect_to :root
    else
      flash.now[:danger] = 'メールアドレスが正しくありません。'
      render action: 'new'
    end
  end

  def update
    @user = User.find_by!(password_reset_token: params[:id])
    @reset_password_form = ResetPasswordForm.new(user_params)
    @reset_password_form.object = @user
    if @reset_password_form.save
      flash[:success] = 'パスワードが再設定されました。'
      redirect_to :root
    elsif @user.password_reset_sent_at < 10.minutes.ago
      flash[:danger] = 'パスワード再設定の時間切れです。'
      redirect_to :new_password_reset
    else
      render action: 'edit'
    end
  end

  private
  def user_params
    params.require(:reset_password_form).permit(
      :email, :new_password, :new_password_confirmation
    )
  end
end
