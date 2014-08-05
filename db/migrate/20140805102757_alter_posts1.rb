class AlterPosts1 < ActiveRecord::Migration
  def change
    add_index :posts, :url
    add_index :posts, :description
  end
end
