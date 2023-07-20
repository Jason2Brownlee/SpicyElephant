class MessagesAddIndexes < ActiveRecord::Migration
  def self.up
    add_index :messages, :deck_id
    add_index :messages, :user_id
  end

  def self.down
    remove_index :messages, :deck_id
    remove_index :messages, :user_id
  end
end
