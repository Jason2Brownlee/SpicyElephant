class FixRuminationResultId < ActiveRecord::Migration
  def self.up
    change_column :cards, :deck_id, :integer, :limit => nil
    
    change_column :decks, :user_id, :integer, :limit => nil
    
    rename_column :ruminations, :result_id, :rumination_result_id
    add_column :ruminations, :user_id, :integer
    change_column :ruminations, :card_id, :integer, :limit => nil
    change_column :ruminations, :rumination_result_id, :integer, :limit => nil
  end

  def self.down
    change_column :cards, :deck_id, :integer, :limit => 11
    
    change_column :decks, :user_id, :integer, :limit => 11
    
    rename_column :ruminations, :rumination_result_id, :result_id
    remove_column :ruminations, :user_id
    change_column :ruminations, :card_id, :integer, :limit => 11
    change_column :ruminations, :result_id, :integer, :limit => 11
  end
end
