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

  def comment_type(comment)
    case comment.type
    when 'sent'
      'コメント'
    when 'replied'
      '返信'
    else
      raise
    end
  end

  def truncated_content(comment)
    truncate comment.content, length: 20
  end

  def link_to_commented_post(comment)
    link_to(comment.post.title, comment.post, target: '_blank')
  end
end
