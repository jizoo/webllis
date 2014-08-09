class CommentsController < Base
  before_action :reject_non_xhr, only: [ :count ]

  def index
    @comments = Comment.comments_for_user(current_user).order(created_at: :desc).page(params[:page])
  end

  # GET
  def trashed
    @comments = Comment.trashed_comments_for_user(current_user).page(params[:page])
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
      @comment.creator = current_user
      @comment.reader = @post.user
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
    comment.update_column(:creator_trashed, true) if comment.creator == current_user
    comment.update_column(:reader_trashed, true) if comment.reader == current_user
    flash[:success] = 'コメントをゴミ箱に移動しました。'
    redirect_to :back
  end

  def recover
    comment = Comment.find(params[:id])
    comment.update_column(:creator_trashed, false) if comment.creator == current_user
    comment.update_column(:reader_trashed, false) if comment.reader == current_user
    flash[:success] = 'コメントを元に戻しました。'
    redirect_to :back
  end

  #GET
  def count
    render text: Comment.unprocessed.where(reader: current_user).count
  end

  private
  def outbound_comment_params
    params.require(:outbound_comment).permit(:content)
  end
end
