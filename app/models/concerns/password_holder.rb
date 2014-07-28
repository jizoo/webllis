module PasswordHolder
  extend ActiveSupport::Concern

  included do
    attr_accessor :password_confirmation, :new_password
    validates :password, length: 6..20, confirmation: true, if: :password || authentications.empty?
  end

  def password=(raw_password)
    @password = raw_password
    if raw_password.kind_of?(String)
      self.hashed_password = BCrypt::Password.create(raw_password)
    elsif raw_password.nil?
      self.hashed_password = nil
    end
  end

  def password
    @password
  end
end
