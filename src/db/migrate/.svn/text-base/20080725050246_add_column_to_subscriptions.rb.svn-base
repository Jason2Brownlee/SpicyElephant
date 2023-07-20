class AddColumnToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :type, :string, :null => false
    type
  end

  def self.down
    remove_column :subscriptions, :type, :string
  end
end
