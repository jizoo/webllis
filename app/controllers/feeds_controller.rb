class FeedsController < ApplicationController
  skip_before_action :authorize

  def index
    @feed_items = SearchForm.new(params[:search])
    if logged_in?
      @feed_items = @feed_items.search.from_users_followed_by(current_user)
    else
      editors = User.where(editor: true)
      @feed_items = @feed_items.search.where(user: editors.ids)
    end
    @feed_items = @feed_items.tagged_with(params[:tag]) if params[:tag].present?
    @feed_items = @feed_items.page(params[:page])
  end

  # GET
  def picked
    editors = User.where(editor: true)
    @feed_items = Post.where(user: editors.ids).page(params[:page])
    render action: 'index'
  end
end
