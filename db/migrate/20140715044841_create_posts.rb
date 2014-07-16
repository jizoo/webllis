class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user, null: false
      t.string :url, null: false
      t.string :title, null: false
      t.string :description
      t.string :image

      t.timestamps
    end

    add_index :posts, [ :user_id, :created_at ]
    add_index :posts, :title
    add_foreign_key :posts, :users
  end
end
