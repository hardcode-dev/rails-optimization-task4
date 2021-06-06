class AddIdCodeToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :id_code, :string
  end
end
