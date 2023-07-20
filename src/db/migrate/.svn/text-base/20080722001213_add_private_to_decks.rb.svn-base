class AddPrivateToDecks < ActiveRecord::Migration
  def self.up
    add_column :decks, :visability, :string, :default => "public"
  end

  def self.down
    remove_column :decks, :visability
  end
end
