class SearchForm
  include ActiveModel::Model

  attr_accessor :title

  def search
    rel = Post.where("title LIKE ?", "%#{title}%") if title.present?
    rel.order(created_at: :desc)
  end
end
