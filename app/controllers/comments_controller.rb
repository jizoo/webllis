class CommentsController < Base
  before_action :reject_non_xhr, only: [ :count ]

  def index
    @comments = Comment.where(discarded: false).page(params[:page])
  end

  # GET
  def discarded
    @comments = Comment.where(discarded: true).page(params[:page])
    render action: 'index'
  end

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
    if params[:post_id]
      @post = Post.find(params[:post_id])
      @comment = @post.comments.find(params[:id])
    else
      @comment = Comment.find(params[:id])
    end
    @comment.destroy
    flash[:success] = 'コメントを削除しました。'
    redirect_to @post || :back
  end

  def trash
    comment = Comment.find(params[:id])
    comment.update_column(:discarded, true)
    flash[:success] = 'コメントをゴミ箱に移動しました。'
    redirect_to :back
  end

  def recover
    comment = Comment.find(params[:id])
    comment.update_column(:discarded, false)
    flash[:success] = 'コメントを元に戻しました。'
    redirect_to :back
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
