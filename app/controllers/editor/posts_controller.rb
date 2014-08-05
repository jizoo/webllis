class Editor::PostsController < Editor::Base
  def index
    @search_form = Editor::SearchForm.new(params[:search])
    @posts = @search_form.search.where(user: current_user.id).page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = '投稿完了しました。'
      redirect_to :editor_posts
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
      redirect_to :editor_posts
    else
      render action: 'edit'
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    redirect_to :editor_posts
  end

  # DELETE
  def delete
    if Editor::PostsDeleter.new.delete(params[:form])
      flash[:success] = '投稿を削除しました。'
    end
    redirect_to action: 'index'
  end

  private
  def post_params
    params.require(:post).permit(:url, :title, :tag_list,
    :image, :image_cache, :remove_image, :description)
  end
end
