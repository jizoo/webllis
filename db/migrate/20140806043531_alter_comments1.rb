class AlterComments1 < ActiveRecord::Migration
  def change
    add_column :comments, :root_id, :integer
    add_column :comments, :parent_id, :integer
    add_column :comments, :type, :string, null: false
    add_column :comments, :status, :string, null: false, default: 'new'
    add_column :comments, :remarks, :text
    add_column :comments, :discarded, :boolean, null: false, default: false
    add_column :comments, :deleted, :boolean, null: false, default: false
    add_index :comments, :user_id
    add_index :comments, [ :type, :user_id ]
    add_index :comments, [ :user_id, :discarded, :created_at ]
    add_index :comments, [ :user_id, :deleted, :created_at ]
    add_index :comments, [ :user_id, :deleted, :status, :created_at ],
      name: 'index_comments_on_u_d_s_c'
    add_index :comments, [ :root_id, :deleted, :created_at ]
    add_foreign_key :comments, :comments, column: 'root_id'
    add_foreign_key :comments, :comments, column: 'parent_id'
  end
end
