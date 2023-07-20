class AddStudyModeToStudySession < ActiveRecord::Migration
  def self.up
    add_column :study_sessions, :study_mode_id, :integer, :null => false
  end

  def self.down
    remove_column :study_sessions, :study_mode_id
  end
end
