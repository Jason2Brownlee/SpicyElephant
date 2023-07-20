class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.references :user
      t.date :start_subscription_at
      t.date :end_subscription_at
      t.text :transcation
      t.date :created_at

      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
