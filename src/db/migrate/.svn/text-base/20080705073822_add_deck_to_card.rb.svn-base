class AddDeckToCard < ActiveRecord::Migration
  def self.up
    add_column :cards, :deck_id, :integer, :limit => 11 
  end

  def self.down
    remove_column :cards, :deck_id
  end
end
