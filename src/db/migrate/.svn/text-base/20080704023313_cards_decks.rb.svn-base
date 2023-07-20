class CardsDecks < ActiveRecord::Migration
  def self.up
    create_table :cards_decks, :id => false do |t|
      t.references :card
      t.references :deck
      
      t.timestamps
    end
  end

  def self.down
    drop_table :cards_decks
  end
end
