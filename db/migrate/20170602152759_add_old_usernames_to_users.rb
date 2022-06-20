class AddOldUsernamesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users,    :old_username, :string
    add_column :users,    :old_old_username, :string
  end
end
