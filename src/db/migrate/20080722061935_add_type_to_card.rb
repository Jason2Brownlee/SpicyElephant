class AddTypeToCard < ActiveRecord::Migration
  def self.up
    add_column :cards, :type, :string
  end

  def self.down
    drop_column :cards, :type
  end
end
