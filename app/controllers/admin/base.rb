class Admin::Base < Base
  # before_action :check_source_ip_address
  before_action :check_timeout
  before_action :require_admin_user

  private
  # def check_source_ip_address
  #   raise IpAddressRejected unless AllowedSource.include?('admin', request.ip)
  # end

  def require_admin_user
    if current_user && !current_user.admin?
      flash[:warning] = '管理者としてログインしてください。'
      redirect_to :root
    end
  end

  TIMEOUT = 30.minutes

  def check_timeout
    if current_user
      if session[:last_access_time] >= TIMEOUT.ago
        session[:last_access_time] = Time.current
      else
        cookies.delete(:remember_token)
        flash[:warning] = 'セッションがタイムアウトしました。'
        redirect_to :admin_login
      end
    end
  end
end
