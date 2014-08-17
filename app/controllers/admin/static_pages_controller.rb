class Admin::StaticPagesController < Admin::ApplicationController
  skip_before_action :authorize

  def home
    if current_user
      render action: 'dashboard'
    else
      render action: 'home'
    end
  end
end
