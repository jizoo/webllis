class CommentsController < ApplicationController
  before_action :reject_non_xhr, only: [ :count ]
  before_action :fetch_comment, only: [ :destroy, :trash, :recover ]
  before_action :fetch_post, only: [ :confirm, :create, :destroy ]
  before_action :set_title, only: [ :index, :trashed ]

  def index
    @comments = Comment.unprocessed_by_creator_or_reader(current_user).page(params[:page])
    @comments.update_all(read: true)
  end

  # GET
  def trashed
    @comments = Comment.trashed_by_creator_or_reader(current_user).page(params[:page])
    render action: 'index'
  end

  # POST
  def confirm
    @comment = comments.build(comment_params)
    if @comment.valid?
      render action: 'confirm'
    else
      @comments = comments.page(params[:page])
      flash.now[:danger] = '入力に誤りがあります。'
      render 'posts/show'
    end
  end

  def create
    @comment = comments.build(comment_params)
    @comment.creator = current_user
    @comment.reader = @post.user
    if params[:commit] && @comment.save
      flash[:success] = 'コメントを投稿しました。'
      redirect_to @post
    else
      @comments = comments.page(params[:page])
      flash.now[:danger] = '入力に誤りがあります。'
      render 'posts/show'
    end
  end

  def destroy
    @comment = comments.find(params[:id]) if params[:post_id]
    if current_user?(@comment.creator)
      @comment.destroy
    else
      @comment.update_column(:deleted, true)
    end
    flash[:success] = 'コメントを削除しました。'
    redirect_to @post || :back
  end

  # PATCH
  def trash
    @comment.update_column(:creator_trashed, true) if @comment.trashable_by_creator?(current_user)
    @comment.update_column(:reader_trashed, true) if @comment.trashable_by_reader?(current_user)
    flash[:success] = 'コメントをゴミ箱に移動しました。'
    redirect_to :back
  end

  # PATCH
  def recover
    @comment.update_column(:creator_trashed, false) if @comment.recoverable_by_creator?(current_user)
    @comment.update_column(:reader_trashed, false) if @comment.recoverable_by_reader?(current_user)
    flash[:success] = 'コメントを元に戻しました。'
    redirect_to :back
  end

  # GET
  def count
    render text: Comment.unread_by(current_user).count
  end

  private

  def set_title
    @title = case params[:action]
      when 'index'; 'コメント一覧'
      when 'trashed'; 'ゴミ箱'
      else; raise
    end
  end

  def comments
    @post ? @post.comments : Comment
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
