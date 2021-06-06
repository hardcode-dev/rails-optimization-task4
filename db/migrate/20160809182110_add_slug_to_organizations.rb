class AddSlugToOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :slug, :string
    add_column :organizations, :nav_image, :string
    add_column :articles, :organization_id, :integer

  end
end
