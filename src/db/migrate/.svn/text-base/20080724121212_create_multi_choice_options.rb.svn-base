class CreateMultiChoiceOptions < ActiveRecord::Migration
  def self.up
    create_table :multi_choice_options do |t|
      t.string :option
      t.integer :card_id, :null => false
      t.boolean :correct, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :multi_choice_options
  end
end
