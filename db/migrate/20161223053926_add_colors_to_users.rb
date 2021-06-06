class AddColorsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :bg_color_hex, :string
    add_column :users, :text_color_hex, :string

  end
end
