class AddBodyTextToLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :links, :body_text, :text
    add_column :links, :base_url, :string
  end
end
