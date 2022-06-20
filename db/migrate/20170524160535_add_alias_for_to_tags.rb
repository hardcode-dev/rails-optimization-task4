class AddAliasForToTags < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :alias_for, :string
  end
end
