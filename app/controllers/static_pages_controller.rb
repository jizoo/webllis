class StaticPagesController < Base
  skip_before_action :authorize

  def home
    if logged_in?
      @feed_items = current_user.feed.page(params[:page])
    end
  end

  def about
  end

  def contact
  end
end
