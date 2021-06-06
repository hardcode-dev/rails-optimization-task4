class DropFeatures < ActiveRecord::Migration[5.1][5.0]
  def change
    drop_table :features
  end
end
