class Event < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :user
  alias_attribute :occurred_at, :created_at

  DESCRIPTIONS = {
    logged_in: 'ログイン',
    logged_out: 'ログアウト',
    rejected: 'ログイン拒否'
  }

  def description
    DESCRIPTIONS[type.to_sym]
  end
end
