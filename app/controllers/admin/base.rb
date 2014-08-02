class Admin::Base < ApplicationController
  before_action :check_source_ip_address
  before_action :authorize
  before_action :check_account
  before_action :check_timeout

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

  def check_source_ip_address
    raise IpAddressRejected unless AllowedSource.include?('admin', request.ip)
  end

  def authorize
    unless current_administrator
      store_location
      flash[:warning] = '管理者としてログインしてください。'
      redirect_to :admin_login
    end
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

  def check_account
    if current_administrator && current_administrator.suspended?
      cookies.delete(:remember_token)
      flash[:warning] = 'アカウントが無効になりました。'
      redirect_to :admin_root
    end
  end

  TIMEOUT = 30.minutes

  def check_timeout
    if current_administrator
      if session[:last_access_time] >= TIMEOUT.ago
        session[:last_access_time] = Time.current
      else
        cookies.delete(:remember_token)
        flash[:warning] = 'セッションがタイムアウトしました。'
        redirect_to :admin_login
      end
    end
  end

  def gravatar_url(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=50"
  end
end
