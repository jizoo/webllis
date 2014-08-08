class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  belongs_to :root, class_name: 'Comment', foreign_key: 'root_id'
  belongs_to :parent, class_name: 'Comment', foreign_key: 'parent_id'
  has_many :children, class_name: 'Comment', foreign_key: 'parent_id'

  validates :content, presence: true, length: { maximum: 800 }

  before_create do
    if parent
      self.user = parent.user
      self.root = parent.root || parent
    end
  end

  before_validation do
    if parent
      self.root = parent.root || parent
      self.user = parent.user
    end
  end

  default_scope { order(created_at: :desc) }
end
