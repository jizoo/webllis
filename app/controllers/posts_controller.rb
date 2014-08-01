class PostsController < Base
  skip_before_action :authorize, only: :show

  def index
    @posts = current_user.posts.page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    if logged_in?
      @comments = @post.comments.page(params[:page])
      @comment = @post.comments.build
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
      redirect_to :posts
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
      redirect_to :posts
    else
      render action: 'edit'
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    redirect_to :posts
  end

  def post_params
    params.require(:post).permit(:url, :title, :tag_list,
    :image, :image_cache, :remove_image, :description)
  end
end
