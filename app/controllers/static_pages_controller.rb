class StaticPagesController < Base
  skip_before_action :authorize

  def home
    if logged_in?
      @feed_items = current_user.feed.page(params[:page])
      if params[:tag]
        @feed_items = current_user.feed.page(params[:page]).tagged_with(params[:tag])
      end
    else
      editor = User.find_by(editor: true)
      @feed_items = editor.posts.page(params[:page])
      if params[:tag]
        @feed_items = editor.posts.page(params[:page]).tagged_with(params[:tag])
      end
    end
    if search_form.title.present?
      @feed_items = search_form.search.page(params[:page])
    end
  end

  def about
  end

  def contact
  end
end
