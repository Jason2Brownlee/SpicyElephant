class AddNotificationToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :last_signin_at, :datetime
    add_column :users, :last_notification_email_at, :datetime
    add_column :users, :notification_enabled, :boolean, :default => true
  end

  def self.down
    remove_column :users, :last_signin_at
    remove_column :users, :last_notification_email_at
    remove_column :users, :notification_enabled
  end
end
