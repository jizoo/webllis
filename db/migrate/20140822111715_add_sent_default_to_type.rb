class AddSentDefaultToType < ActiveRecord::Migration
  def change
    change_column_default :comments, :type, 'sent'
  end
end
