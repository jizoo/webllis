class Administrator < ActiveRecord::Base
  include EmailHolder
  include PasswordHolder

  before_create :create_remember_token

  def Administrator.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Administrator.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
  def create_remember_token
    self.remember_token = Administrator.encrypt(Administrator.new_remember_token)
  end
end
