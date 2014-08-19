module NameHolder
  extend ActiveSupport::Concern

  NAME_REGEXP = /\A[a-z\d\_]+\z/i

  included do
    include StringNormalizer

    before_validation do
      self.name = normalize(name)
    end

    validates :name, length: 3..50,
      uniqueness: { case_sensitive: false, allow_blank: true },
      format: { with: NAME_REGEXP, allow_blank: true }
  end
end
