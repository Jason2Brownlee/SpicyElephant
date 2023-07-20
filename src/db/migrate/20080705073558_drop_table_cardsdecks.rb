class DropTableCardsdecks < ActiveRecord::Migration
  def self.up
    drop_table :cards_decks
  end

  def self.down
    create_table :cards_decks, :id => false do |t|
      t.references :card
      t.references :deck
      
      t.timestamps
    end
  end
end
