class AddboToCardy < ActiveRecord::Migration
  def self.up
    add_column :cardies, :bob, :string
  end

  def self.down
  end
end
