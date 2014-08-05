class Editor::SearchForm
  include ActiveModel::Model

  attr_accessor :url, :title, :description

  def search
    rel = Post
    rel = rel.where("url LIKE ?", "%#{url}%") if url.present?
    rel = rel.where("title LIKE ?", "%#{title}%") if title.present?
    rel = rel.where("description LIKE ?", "%#{description}%") if description.present?

    rel.order(created_at: :desc)
  end
end
