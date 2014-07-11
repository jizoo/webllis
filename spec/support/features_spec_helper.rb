module FeaturesSpecHelper
  def login(user)
    remember_token = SecureRandom.urlsafe_base64
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, Digest::SHA1.hexdigest(remember_token.to_s))
  end
end
