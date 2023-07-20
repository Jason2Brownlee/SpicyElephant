class AddUserToDeck < ActiveRecord::Migration
  def self.up
     add_column :decks, :user_id, :integer
  end

  def self.down
    remove_column :decks, :user_id
  end
end
