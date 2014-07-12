class Admin::StaticPagesController < Admin::Base
  skip_before_action :authorize

  def home
    if current_administrator
      render action: 'dashboard'
    else
      render action: 'home'
    end
  end
end
