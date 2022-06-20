class AddActiveToLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :links, :active, :boolean, default: true
  end
end
