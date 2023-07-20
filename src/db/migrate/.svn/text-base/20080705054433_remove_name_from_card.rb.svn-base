class RemoveNameFromCard < ActiveRecord::Migration
  def self.up
    remove_column :cards, :name
  end

  def self.down
    add_column :cards, :name, :string
  end
end
