class ChangeAuthorIdToUserId < ActiveRecord::Migration[5.1]
  def change
    rename_column :articles, :author_id, :user_id

  end
end
