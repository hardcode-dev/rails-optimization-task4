class AddPolymorphismToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :commentable_id, :integer
    add_column :comments, :commentable_type, :string
    add_column :comments, :score, :integer, default: 0
  end
end
