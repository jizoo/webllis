class AddRememberTokenToAdministrators < ActiveRecord::Migration
  def change
    add_column :administrators, :remember_token, :string
    add_index :administrators, :remember_token
  end
end
