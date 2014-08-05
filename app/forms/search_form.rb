class SearchForm
  include ActiveModel::Model

  attr_accessor :title

  def search
    rel = Post
    rel = rel.where("title LIKE ?", "%#{title}%") if title.present?
    rel.order(created_at: :desc)
  end
end
