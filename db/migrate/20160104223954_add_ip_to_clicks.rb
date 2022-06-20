class AddIpToClicks < ActiveRecord::Migration[5.1]
  def change
    add_column :ad_clicks, :ip, :string
  end
end
