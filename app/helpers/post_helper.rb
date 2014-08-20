module PostHelper
  def post_image(post)
    if post.image.present?
      image_tag post.image.url, alt: 'post', class: 'img-responsive'
    else
      image_tag 'no_thumbnail.gif', alt: 'post', class: 'img-responsive'
    end
  end

  def trancated_description(post)
    truncate post.description, length: 200
  end

  def tags_for_post(post)
    raw post.tag_list.map { |t| link_to t, tag_path(t) }.join(', ')
  end
end
