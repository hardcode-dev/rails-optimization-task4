class ChangeGithubIssueColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :github_issues, :type, :category
  end
end
