class ResetPasswordForm
  include ActiveModel::Model

  attr_accessor :object, :email, :new_password, :new_password_confirmation
  validates :new_password, length: 6..20, confirmation: true

  def save
    if valid?
      object.password = new_password
      object.save!
    end
  end
end
