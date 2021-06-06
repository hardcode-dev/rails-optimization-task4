class AddAnchorToAdd < ActiveRecord::Migration[5.1]
  def change
    add_column :advertisements, :anchor_text, :string
  end
end
