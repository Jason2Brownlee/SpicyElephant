class DropTypeFromCard < ActiveRecord::Migration
  def self.up
    remove_column :cards, :type
  end

  def self.down
    add_column :cards, :type, :string
  end
end
