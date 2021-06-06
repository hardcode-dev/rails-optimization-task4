class AddPatternImageToSponsors < ActiveRecord::Migration[5.1]
  def change
    add_column :sponsors, :pattern_image, :string
    add_column :sponsors, :subheadline, :string
  end
end
