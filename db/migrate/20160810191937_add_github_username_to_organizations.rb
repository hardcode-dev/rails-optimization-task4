class AddGithubUsernameToOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :github_username, :string
  end
end
