class RenameAuthorsToUsers < ActiveRecord::Migration[5.1]
  def change
    rename_table :authors, :users
  end
end
