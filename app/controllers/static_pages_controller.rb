class StaticPagesController < Base
  skip_before_action :authorize

  def home
    if logged_in?
      if search_form.title.present?
        @feed_items = search_form.search.page(params[:page])
      else
        @feed_items = current_user.feed.page(params[:page])
        if params[:tag]
          @feed_items = current_user.feed.page(params[:page]).tagged_with(params[:tag])
        end
      end
    end
  end

  def about
  end

  def contact
  end
end
