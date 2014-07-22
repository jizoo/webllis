class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :post, null: false
      t.references :user, null: false
      t.string :content, null: false

      t.timestamps
    end

    add_foreign_key :comments, :posts
    add_foreign_key :comments, :users
  end
end
