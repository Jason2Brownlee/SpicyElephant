class DeckAddIndexes < ActiveRecord::Migration
  def self.up
    add_index :decks, :user_id
  end

  def self.down
    remove_index :decks, :user_id
  end
end
