class Post < ActiveRecord::Base
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :post
  has_many :comments, dependent: :destroy
  has_many :outbound_comments, dependent: :destroy

  default_scope -> { order(created_at: :desc)}
  validates :url, presence: true
  validates :title, presence: true
  validates :description, length: { maximum: 4000 }
  mount_uploader :image, ImageUploader
  acts_as_taggable

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
      WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
      user_id: user.id)
  end
end
