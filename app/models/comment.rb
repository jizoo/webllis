class Comment < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :post
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  belongs_to :reader, class_name: 'User', foreign_key: 'reader_id'
  belongs_to :root, class_name: 'Comment', foreign_key: 'root_id'
  belongs_to :parent, class_name: 'Comment', foreign_key: 'parent_id'
  has_many :children, class_name: 'Comment', foreign_key: 'parent_id'

  scope :unprocessed, -> { where(read: false, reader_trashed: false) }

  validates :content, presence: true, length: { maximum: 400 }

  before_create { self.root = parent.root || parent if parent }
  before_validation { self.root = parent.root || parent if parent }


  def self.comments_for_user(user)
    reader = arel_table[:reader_id].eq(user.id)
    creator = arel_table[:creator_id].eq(user.id)
    reader_not_trashed = arel_table[:reader_trashed].eq(false)
    creator_not_trashed = arel_table[:creator_trashed].eq(false)
    not_deleted = arel_table[:deleted].eq(false)
    where(arel_table.grouping(
      (reader.and(reader_not_trashed)).or(creator.and(creator_not_trashed))
      .and(not_deleted))
    )
  end

  def self.trashed_comments_for_user(user)
    reader = arel_table[:reader_id].eq(user.id)
    creator = arel_table[:creator_id].eq(user.id)
    reader_trashed = arel_table[:reader_trashed].eq(true)
    creator_trashed = arel_table[:creator_trashed].eq(true)
    not_deleted = arel_table[:deleted].eq(false)
    where(arel_table.grouping(
      (reader.and(reader_trashed)).or(creator.and(creator_trashed))
      .and(not_deleted))
    )
  end
end
