class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.order(:name).page(params[:page])
  end

  def show
    user = User.find(params[:id])
    redirect_to [ :edit, :admin, user ]
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    @user.icon_image = gravatar_url(@user)
    if @user.save
      flash[:success] = 'アカウントを新規登録しました。'
      redirect_to :admin_users
    else
      render action: 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    @user.assign_attributes(user_params)
    if @user.save
      flash[:success] = 'アカウントを更新しました。'
      redirect_to :admin_users
    else
      render action: 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy!
    flash[:success] = 'アカウントを削除しました。'
    redirect_to :admin_users
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation, :suspended, :editor, :admin)
  end
end
