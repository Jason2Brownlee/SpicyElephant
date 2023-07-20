class AddDefaultInstructionToDeck < ActiveRecord::Migration
  def self.up
    add_column :decks, :instruction, :string
  end

  def self.down
    remove_column :decks, :instruction
  end
end
