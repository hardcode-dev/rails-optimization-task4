class AddEditedAtToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :edited_at, :datetime
  end
end
