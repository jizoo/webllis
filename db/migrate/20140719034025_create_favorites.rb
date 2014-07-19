class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :user, null: false
      t.references :post, null: false

      t.timestamps
    end

    add_index :favorites, :user_id
    add_index :favorites, :post_id
    add_index :favorites, [ :user_id, :post_id ], unique: true
  end
end
