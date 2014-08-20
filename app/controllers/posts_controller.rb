class PostsController < ApplicationController
  skip_before_action :authorize, only: [ :index, :show ]

  def index
    @posts = SearchForm.new(params[:search])
    if logged_in?
      @posts = @posts.search.from_users_followed_by(current_user)
    else
      editors = User.where(editor: true)
      @posts = @posts.search.where(user: editors.ids)
    end
    @posts = @posts.tagged_with(params[:tag]) if params[:tag].present?
    @posts = @posts.page(params[:page])
  end

  # GET
  def posted
    @posts = current_user.posts.page(params[:page])
    render action: 'index'
  end

  # GET
  def favorite
    @posts = current_user.favorite_posts.page(params[:page])
    render action: 'index'
  end

  # GET
  def picked
    editors = User.where(editor: true)
    @posts = Post.where(user: editors.ids).page(params[:page])
    render action: 'index'
  end

  def show
    @post = Post.find(params[:id])
    if logged_in?
      @comment = @post.comments.build
      @comments = @post.comments.where(type: 'sent').page(params[:page])
    end
    authorize unless @post.user.editor?
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = '投稿完了しました。'
      redirect_to @post
    else
      render action: 'new'
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    @post.assign_attributes(post_params)
    if @post.save
      flash[:success] = '投稿を更新しました。'
      redirect_to @post
    else
      render action: 'edit'
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy!
    redirect_to :root
  end

  private

  def post_params
    params.require(:post).permit(
      :url, :title, :tag_list, :image,
      :image_cache, :remove_image, :description
    )
  end
end
