module CommentHelper
  def comment_created_at(comment)
    if comment.created_at > Time.current.midnight
      comment.created_at.strftime('%H:%M:%S')
    elsif comment.created_at > 5.months.ago.beginning_of_month
      comment.created_at.strftime('%m/%d %H:%M')
    else
      comment.created_at.strftime('%Y/%m/%d %H:%M')
    end
  end
end
