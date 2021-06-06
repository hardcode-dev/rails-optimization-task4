class AddScretToSponsors < ActiveRecord::Migration[5.1]
  def change
    add_column :sponsors, :url_secret, :string
  end
end
