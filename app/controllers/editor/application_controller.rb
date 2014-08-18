class Editor::ApplicationController < ApplicationController
  before_action :check_source_ip_address
  before_action :check_timeout
  before_action :require_editor_user

  private
  def check_source_ip_address
    raise IpAddressRejected unless AllowedSource.include?('editor', request.ip)
  end

  def require_editor_user
    if current_user && !current_user.editor?
      flash[:warning] = '編集者としてログインしてください。'
      redirect_to :root
    end
  end

  TIMEOUT = 30.minutes

  def check_timeout
    if current_user
      if session[:last_access_time] >= TIMEOUT.ago
        session[:last_access_time] = Time.current
      else
        session.delete(:user_id)
        flash[:warning] = 'セッションがタイムアウトしました。'
        redirect_to :editor_login
      end
    end
  end
end
