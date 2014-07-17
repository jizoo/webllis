class Post < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc)}
  validates :url, presence: true
  validates :title, presence: true
  validates :description, length: { maximum: 140 }
  mount_uploader :image, ImageUploader
end
