class AddForeignKeyToFavorites < ActiveRecord::Migration
  def change
    add_foreign_key :favorites, :users
    add_foreign_key :favorites, :posts
  end
end
