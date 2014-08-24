class User < ActiveRecord::Base
  include NameHolder
  include EmailHolder
  include PasswordHolder

  has_many :events, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :relationships, foreign_key: 'follower_id', dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: 'followed_id',
    class_name: 'Relationship', dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post
  has_many :comments, dependent: :destroy, foreign_key: :creator_id
  has_many :authentications, dependent: :destroy

  default_scope { order(created_at: :desc) }

  def send_password_reset
    self.password_reset_token = User.encrypt(User.new_remember_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def active?
    !suspended?
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  def favorite?(other_post)
    favorites.find_by(post_id: other_post.id)
  end

  def add_favorite!(other_post)
    favorites.create!(post_id: other_post.id)
  end

  def remove_favorite!(other_post)
    favorites.find_by(post_id: other_post.id).destroy
  end

  def apply_oauth(oauth)
    provider = oauth['provider']
    uid = oauth['uid']
    nickname = oauth['info']['nickname']
    image_url = oauth['info']['image']

    self.name = nickname if name.blank?
    self.icon_image = image_url if new_record?
    authentications.build(provider: provider, uid: uid) do |user|
      user.nickname = nickname
      user.image = image_url
    end
  end
end
