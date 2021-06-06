class AddDescriptionToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :job_listings, :description, :string
  end
end
