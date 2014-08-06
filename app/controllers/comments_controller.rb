class CommentsController < Base
  before_action :reject_non_xhr, only: [ :count ]

  # POST
  def confirm
    @post = Post.find(params[:post_id])
    @comment = @post.outbound_comments.build(outbound_comment_params)
    if @comment.valid?
      render action: 'confirm'
    else
      @comments = @post.comments.page(params[:page])
      flash.now[:danger] = '入力に誤りがあります。'
      render 'posts/show'
    end
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.outbound_comments.build(outbound_comment_params)
    if params[:commit]
      @comment.user_id = current_user.id
      if @comment.save
        flash[:success] = 'コメントを投稿しました。'
        redirect_to @post
      else
        @comments = @post.comments.page(params[:page])
        flash.now[:danger] = '入力に誤りがあります。'
        render 'posts/show'
      end
    else
      @comments = @post.comments.page(params[:page])
      render 'posts/show'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    flash[:success] = 'コメントを削除しました。'
    redirect_to @post
  end

  #GET
  def count
    current_user_post_id = current_user.posts.pluck(:id)
    render text: OutboundComment.unprocessed.where(post_id: current_user_post_id).count
  end

  private
  def outbound_comment_params
    params.require(:outbound_comment).permit(:content)
  end
end
