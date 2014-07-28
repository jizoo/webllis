class AddNicknameAndImageToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :nickname, :string, null: false
    add_column :authentications, :image, :string, null: false
  end
end
