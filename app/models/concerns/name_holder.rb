module NameHolder
  extend ActiveSupport::Concern

  NAME_REGEXP = /\A[a-z\d\_]+\z/i

  included do
    include StringNormalizer

    before_validation do
      self.name = normalize_as_name(name)
    end

    validates :name, presence: true, length: 3..50,
      format: { with: NAME_REGEXP, allow_blank: true }
  end
end
