class FeedsController < ApplicationController
  skip_before_action :authorize

  def index
    if logged_in?
      @feed_items = current_user.feed.page(params[:page])
      if params[:tag]
        @feed_items = @feed_items.tagged_with(params[:tag])
      end
      if search_form.title
        @feed_items = search_form.search.page(params[:page])
      end
    else
      editors = User.where(editor: true)
      @feed_items = search_form.search.where(user: editors.ids).page(params[:page])
      if params[:tag]
        @feed_items = Post.where(user: editors.ids).page(params[:page]).tagged_with(params[:tag])
      end
    end
  end

  def picked
    editors = User.where(editor: true)
    @feed_items = Post.where(user: editors.ids).page(params[:page])
  end
end
