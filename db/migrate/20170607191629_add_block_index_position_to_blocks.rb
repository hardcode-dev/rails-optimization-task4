class AddBlockIndexPositionToBlocks < ActiveRecord::Migration[5.1]
  def change
    add_column :blocks, :index_position, :integer
  end
end
