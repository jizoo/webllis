class OutboundComment < Comment
  scope :unprocessed, -> { where(status: 'new', deleted: false) }
end
