class StaticPagesController < Base
  skip_before_action :authorize

  def home
    if logged_in?
      if search_form.title.present?
        @feed_items = search_form.search.page(params[:page])
      else
        @feed_items = current_user.feed.page(params[:page])
      end
    end
  end

  def about
  end

  def contact
  end
end
