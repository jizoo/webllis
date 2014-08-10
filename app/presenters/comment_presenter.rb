class CommentPresenter < ModelPresenter
  delegate :content, to: :object

  def type
    case object.type
    when 'sent'
      'コメント'
    when 'replied'
      '返信'
    else
      raise
    end
  end

  def creator_link
    view_context.link_to(object.creator.name, object.creator, target: '_blank')
  end

  def truncated_content
    view_context.truncate(content, length: 20)
  end

  def commented_post
    view_context.link_to(object.post.title, object.post, target: '_blank')
  end

  def created_at
    if object.created_at > Time.current.midnight
      object.created_at.strftime('%H:%M:%S')
    elsif object.created_at > 5.months.ago.beginning_of_month
      object.created_at.strftime('%m/%d %H:%M')
    else
      object.created_at.strftime('%Y/%m/%d %H:%M')
    end
  end
end
