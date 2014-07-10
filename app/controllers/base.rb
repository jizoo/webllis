class Base < ApplicationController
  private
  def login(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  helper_method :current_user

  def logged_in?
    !current_user.nil?
  end

  helper_method :logged_in?

  def logout
    self.current_user = nil
    cookies.delete(:remember_token)
  end
end
