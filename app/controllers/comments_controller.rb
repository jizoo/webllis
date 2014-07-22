class CommentsController < Base
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = 'コメントを投稿しました。'
      redirect_to @post
    else
      @comments = @post.comments.page(params[:page])
      render 'posts/show'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    flash[:success] = 'コメントが削除されました。'
    redirect_to @post
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
