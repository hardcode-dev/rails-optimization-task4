class AddBumpedAtToJobListings < ActiveRecord::Migration[5.1]
  def change
    add_column :job_listings, :bumped_at, :datetime
  end
end
