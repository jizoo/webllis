class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.references :user, index: true
      t.string :provider, null:false
      t.string :uid, null:false

      t.timestamps
    end

    add_index :authentications, [:uid, :provider], unique: true
    add_foreign_key :authentications, :users
  end
end
