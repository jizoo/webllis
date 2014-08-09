module ApplicationHelper
  include HtmlBuilder

  def full_title(page_title)
    base_title = "Webllis"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def number_of_unprocessed_comments
    markup do |m|
      m << '新規コメント'
      if (c = Comment.unprocessed.where(reader: current_user).count) > 0
        anchor_text = "(#{c})"
      else
        anchor_text = ''
      end
      m.span(anchor_text, id: 'number-of-unprocessed-comments')
    end
  end

  def formatted_content(content)
    ERB::Util.html_escape(content).gsub(/\n/, '<br />').html_safe
  end
end
