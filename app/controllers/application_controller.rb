class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout :set_layout

  before_action :authorize
  before_action :check_account

  class Forbidden < ActionController::ActionControllerError; end
  class IpAddressRejected < ActionController::ActionControllerError; end

  include ErrorHandlers unless Rails.env.development?
  rescue_from ApplicationController::Forbidden, with: :rescue403
  rescue_from ApplicationController::IpAddressRejected, with: :rescue403

  private
  def set_layout
    if params[:controller].match(%r{\A(editor|admin)/})
      Regexp.last_match[1]
    else
      'application'
    end
  end

  def rescue403(e)
    @exception = e
    render 'errors/forbidden', status: 403
  end

  def reject_non_xhr
    raise ActionController::BadRequest unless request.xhr?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    user_id = cookies.signed[:user_id] || session[:user_id]
    @current_user ||= User.find_by(id: user_id)
  end

  helper_method :current_user

  def current_user?(user)
    user == current_user
  end

  helper_method :current_user?

  def logged_in?
    !current_user.nil?
  end

  helper_method :logged_in?

  def authorize
    unless current_user
      store_location
      flash[:warning] = 'ログインしてください。'
      if params[:controller].match(%r{\A(editor)/})
        redirect_to :"#{Regexp.last_match[1]}_login"
      else
        redirect_to :login
      end
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
    if current_user && !current_user.active?
      session.delete(:user_id)
      flash[:warning] = 'アカウントが無効になりました。'
      redirect_to :root
    end
  end

  def search_form
    SearchForm.new(params[:search])
  end

  helper_method :search_form

  def gravatar_url(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=50"
  end

  helper_method :gravatar_url
end
