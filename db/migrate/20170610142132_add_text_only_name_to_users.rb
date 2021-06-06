class AddTextOnlyNameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :text_only_name, :string
  end
end
