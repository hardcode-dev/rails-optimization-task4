class AddMarkdownCharacterCountToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :markdown_character_count, :integer
  end
end
