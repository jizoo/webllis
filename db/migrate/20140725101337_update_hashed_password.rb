class UpdateHashedPassword < ActiveRecord::Migration
  def up
    change_column :users, :hashed_password, :string, null: true
  end

  def down
    change_column :users, :hashed_password, :string, null: false
  end
end
