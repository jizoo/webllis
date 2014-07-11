class Admin::StaticPagesController < Admin::Base
  def home
    if current_administrator
      render action: 'dashboard'
    else
      render action: 'home'
    end
  end
end
