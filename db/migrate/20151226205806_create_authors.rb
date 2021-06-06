class CreateAuthors < ActiveRecord::Migration[5.1]
  def change
    create_table :authors do |t|
      t.string :name
      t.string :twitter_username
      t.string :github_username
      t.timestamps null: false
    end
  end
end
