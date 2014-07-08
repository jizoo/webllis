class UsersController < Base
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "登録完了しました。"
      redirect_to :root
    else
      render action: 'new'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end
end
