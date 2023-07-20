class CreatedResults < ActiveRecord::Migration
  def self.up
    create_table :rumination_results do |t|
      t.string :name
      t.text   :description
    end
    
    RuminationResult.create :name => "Bright", :description => "Excellent response given without hesitation"
    RuminationResult.create :name => "Good", :description => "Correct Response"
    RuminationResult.create :name => "Pass", :description => "Mostly correct response recalled with some effort"
    RuminationResult.create :name => "Fail", :description => "Fucked it up"
    RuminationResult.create :name => "Bad", :description => "Not even close"
    RuminationResult.create :name => "Null", :description => "huh?"
    
    create_table :ruminations do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :result_id
      t.integer  :card_id
    end
    
    change_column :cards, :deck_id, :integer, :limit => nil
  end

  def self.down
    change_column :cards, :deck_id, :integer, :limit => 11
    
    drop_table :rumination_results
    drop_table :ruminations
  end
end
