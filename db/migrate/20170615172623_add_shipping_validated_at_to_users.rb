class AddShippingValidatedAtToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :shipping_validated_at, :datetime
  end
end
