class AddTrainingModeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :training_method, :string, :default => "leitner"
  end

  def self.down
    remove_column :users, :training_method
  end
end
