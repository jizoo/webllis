class Post < ActiveRecord::Base
  include StringNormalizer

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :post
  has_many :comments, dependent: :destroy

  default_scope { order(created_at: :desc) }
  scope :from_editors, -> { where(user: User.where(editor: true).ids) }

  before_validation do
    self.url = normalize(url)
    self.url = url.downcase.gsub(' ', '') if url
    self.title = normalize(title)
    self.description = normalize(description)
  end

  validates :url, format: { with: URI::regexp(%w(http https)) }
  validates :title, length: 3..50
  validates :description, length: { maximum: 1000 }

  mount_uploader :image, ImageUploader
  acts_as_taggable

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
      WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
      user_id: user.id)
  end
end
