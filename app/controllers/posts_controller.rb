class PostsController < ApplicationController
  skip_before_action :authorize, only: [ :index, :show ]
  before_action :fetch_post, only: [ :edit, :update, :destroy ]
  before_action :set_title, only: [ :index, :posted, :favorite, :picked ]

  def index
    @posts = SearchForm.new(params[:search])
    if logged_in?
      @posts = @posts.search.from_users_followed_by(current_user)
    else
      @posts = @posts.search.from_editors
    end
    @posts = @posts.tagged_with(params[:tag]) if params[:tag].present?
    @posts = @posts.page(params[:page])
  end

  # GET
  def posted
    @posts = posts.page(params[:page])
    render action: 'index'
  end

  # GET
  def favorite
    @posts = current_user.favorite_posts.page(params[:page])
    render action: 'index'
  end

  # GET
  def picked
    @posts = Post.from_editors.page(params[:page])
    render action: 'index'
  end

  def show
    @post = Post.find(params[:id])
    if logged_in?
      @comment = @post.comments.build
      @comments = @post.comments.sent.page(params[:page])
    end
    authorize unless @post.user.editor?
  end

  def new
    @post = posts.build
  end

  def create
    @post = posts.build(post_params)
    if @post.save
      flash[:success] = '投稿完了しました。'
      redirect_to @post
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    @post.assign_attributes(post_params)
    if @post.save
      flash[:success] = '投稿を更新しました。'
      redirect_to @post
    else
      render action: 'edit'
    end
  end

  def destroy
    @post.destroy!
    redirect_to :root
  end

  private

  def set_title
    @title = nil if params[:tag].blank? && params[:search].blank?
    @title = "#{params[:tag]}に関する投稿" if params[:tag].present?
    @title = "#{params[:search][:title]}の検索結果" if params[:search].present? && params[:search][:title].present?
    @title = '検索ワードが入力されていません。' if params[:search].present? && params[:search][:title].blank?
    @title = case params[:action]
      when 'index'; @title
      when 'posted'; '自分の投稿一覧'
      when 'favorite'; 'お気に入りの投稿一覧'
      when 'picked'; '編集者の投稿一覧'
      else; raise
    end
  end

  def fetch_post
    @post = posts.find(params[:id])
  end

  def posts
    current_user.posts
  end

  def post_params
    params.require(:post).permit(
      :url, :title, :tag_list, :image,
      :image_cache, :remove_image, :description
    )
  end
end
