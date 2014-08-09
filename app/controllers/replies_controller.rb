class RepliesController < Base
  before_action :prepare_post
  before_action :prepare_comment

  def new
    @reply = InboundComment.new
  end

  # POST
  def confirm
    @reply = InboundComment.new(inbound_comment_params)
    if @reply.valid?
      render action: 'confirm'
    else
      flash.now.alert = '入力に誤りがあります。'
      render action: 'new'
    end
  end

  def create
    @reply = InboundComment.new(inbound_comment_params)
    if params[:commit]
      @reply.creator = current_user
      @reply.reader = @comment.creator
      @reply.post = @post
      @reply.parent = @comment
      if @reply.save
        flash[:success] = 'コメントに返信しました。'
        redirect_to @post
      else
        flash.now[:danger] = '入力に誤りがあります。'
        render action: 'new'
      end
    else
      render action: 'new'
    end
  end

  private
  def prepare_post
    @post = Post.find(params[:post_id])
  end

  def prepare_comment
    @comment = Comment.find(params[:comment_id])
  end

  def inbound_comment_params
    params.require(:inbound_comment).permit(:content)
  end
end
