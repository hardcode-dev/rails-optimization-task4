class AddGithubPathToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :github_path, :string
  end
end
