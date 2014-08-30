class Comment < ActiveRecord::Base
  include StringNormalizer

  self.inheritance_column = nil

  belongs_to :post
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  belongs_to :reader, class_name: 'User', foreign_key: 'reader_id'
  belongs_to :root, class_name: 'Comment', foreign_key: 'root_id'
  belongs_to :parent, class_name: 'Comment', foreign_key: 'parent_id'
  has_many :children, class_name: 'Comment', foreign_key: 'parent_id'

  validates :content, presence: true, length: { maximum: 400 }

  before_validation { self.content = normalize(content) }

  before_create do
    if parent
      self.reader = parent.creator
      self.root = parent.root
      self.type = 'replied'
    end
  end

  scope :sent, -> { where(type: 'sent') }
  scope :reader, ->(user) { arel_table[:reader_id].eq(user.id) }
  scope :creator, ->(user) { arel_table[:creator_id].eq(user.id) }
  scope :trashed_by_reader, -> { arel_table[:reader_trashed].eq(true) }
  scope :trashed_by_creator, -> { arel_table[:creator_trashed].eq(true) }
  scope :not_trashed_by_reader, -> { arel_table[:reader_trashed].eq(false) }
  scope :not_trashed_by_creator, -> { arel_table[:creator_trashed].eq(false) }
  scope :not_deleted_by_reader, -> { arel_table[:deleted].eq(false) }

  class << self
    def unprocessed_by_creator_or_reader(user)
      where(
        (not_deleted_by_reader.and(not_trashed_by_reader).and(reader(user))).
        or(not_trashed_by_creator.and(creator(user)))
      ).
      order(created_at: :desc)
    end

    def trashed_by_creator_or_reader(user)
      where(
        (not_deleted_by_reader.and(trashed_by_reader).and(reader(user))).
        or(trashed_by_creator.and(creator(user)))
      ).
      order(created_at: :desc)
    end

    def unread_by(user)
      where(read: false, reader_trashed: false, reader: user)
    end
  end

  def trashable_by_reader?(user)
    self.reader_trashed == false && self.reader == user
  end

  def trashable_by_creator?(user)
    self.creator_trashed == false && self.creator == user
  end

  def recoverable_by_reader?(user)
    self.reader_trashed == true && self.reader == user
  end

  def recoverable_by_creator?(user)
    self.creator_trashed == true && self.creator == user
  end
end
