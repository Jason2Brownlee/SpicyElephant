class ChangeColumn < ActiveRecord::Migration
  def self.up
    change_column :decks, :description, :text
  end

  def self.down
    change_column :decks, :description, :string
  end
end
