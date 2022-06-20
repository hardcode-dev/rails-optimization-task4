class AddSocialImageToTags < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :social_image, :string
  end
end
