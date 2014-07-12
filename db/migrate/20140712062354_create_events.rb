class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user, null: false
      t.string :type, null: false
      t.datetime :created_at, null: false
    end

    add_index :events, :created_at
    add_index :events, [ :user_id, :created_at ]
    add_foreign_key :events, :users
  end
end
