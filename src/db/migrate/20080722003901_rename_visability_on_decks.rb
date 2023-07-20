class RenameVisabilityOnDecks < ActiveRecord::Migration
  def self.up
    rename_column :decks, :visability, :visibility
  end

  def self.down
    rename_column :decks, :visibility, :visability
  end
end
