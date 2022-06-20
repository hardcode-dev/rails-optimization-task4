class AddNotificationReminderEmailToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :email_unread_notifications, :boolean, default:true
  end
end
