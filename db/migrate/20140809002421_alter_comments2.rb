class AlterComments2 < ActiveRecord::Migration
  def change
    add_column :comments, :creator_id, :integer, null: false
    add_column :comments, :reader_id, :integer, null: false
    add_column :comments, :creator_trashed, :boolean, default: false
    add_column :comments, :reader_trashed, :boolean, default: false
    add_column :comments, :read, :boolean, default: false
    add_index :comments, :creator_id
    add_index :comments, :reader_id
    add_index :comments, [ :creator_id, :creator_trashed, :created_at ],
      name: 'index_comments_on_s_t_c'
    add_index :comments, [ :reader_id, :reader_trashed, :created_at ],
      name: 'index_comments_on_r_t_c'
    add_index :comments, [ :reader_id, :read ]
    add_foreign_key :comments, :users, column: 'creator_id'
    add_foreign_key :comments, :users, column: 'reader_id'

    remove_foreign_key :comments, :users
    remove_index :comments, [ :user_id, :discarded, :created_at ]
    remove_index :comments, [ :user_id, :deleted, :created_at ]
    remove_index :comments, name: 'index_comments_on_u_d_s_c'
    remove_column :comments, :user_id, :integer
    remove_column :comments, :status, :string, null: false, default: 'new'
    remove_column :comments, :remarks, :text
    remove_column :comments, :discarded, :boolean, null: false, default: false
    remove_column :comments, :deleted, :boolean, null: false, default: false
  end
end
