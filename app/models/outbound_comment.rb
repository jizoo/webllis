class OutboundComment < Comment
  scope :unprocessed, -> { where(status: 'new', discarded: false) }
end
