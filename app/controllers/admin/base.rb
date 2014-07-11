class Admin::Base < ApplicationController
  private
  def login(administrator)
    remember_token = Administrator.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    administrator.update_attribute(:remember_token, Administrator.encrypt(remember_token))
    self.current_administrator = administrator
  end

  def current_administrator=(administrator)
    @current_administrator = administrator
  end

  def current_administrator
    remember_token = Administrator.encrypt(cookies[:remember_token])
    @current_administrator ||= Administrator.find_by(remember_token: remember_token)
  end

  helper_method :current_administrator

  def logged_in?
    !current_administrator.nil?
  end

  helper_method :logged_in?

  def logout
    self.current_administrator = nil
    cookies.delete(:remember_token)
  end
end
