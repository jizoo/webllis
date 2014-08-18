class RemoveRememberTokenFromUsers < ActiveRecord::Migration
  def change
    remove_index :users, :remember_token
    remove_column :users, :remember_token, :string
  end
end
