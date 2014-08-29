module EmailHolder
  extend ActiveSupport::Concern

  included do
    include StringNormalizer

    validates :email, presence: true, email: { allow_blank: true }
    validates :email_for_index, uniqueness: { allow_blank: true }

    before_validation do
      self.email = normalize(email)
      self.email_for_index = email.downcase if email
    end

    after_validation do
      if errors.include?(:email_for_index)
        errors.add(:email, :taken)
        errors.delete(:email_for_index)
      end
    end
  end
end
