class AddSponsorIdToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :sponsor_id, :integer
    add_column :articles, :sponsor_showing, :boolean, default: false

  end
end
