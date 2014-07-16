class User < ActiveRecord::Base
  include NameHolder
  include EmailHolder
  include PasswordHolder

  has_many :events, dependent: :destroy
  has_many :posts, dependent: :destroy
  before_create :create_remember_token

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def active?
    !suspended?
  end

  def feed
    Post.where('user_id = ?', id)
  end

  private
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end
