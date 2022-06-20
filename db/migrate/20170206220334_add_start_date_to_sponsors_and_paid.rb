class AddStartDateToSponsorsAndPaid < ActiveRecord::Migration[5.1]
  def change
    add_column :sponsors, :start_date, :datetime
    add_column :sponsors, :amount_paid, :float
  end
end
