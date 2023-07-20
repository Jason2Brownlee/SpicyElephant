class AddStudyModeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :preferred_study_mode_id, :integer, :default => 2
    remove_column :users, :training_method
  end

  def self.down
    remove_column :users, :preferred_study_mode_id
    add_column :users, :training_method, :string, :default => "leitner"
  end
end
