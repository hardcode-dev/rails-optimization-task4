class AddShippingValidatedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :shipping_validated, :boolean, default: false
  end
end
