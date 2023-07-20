class AddStudySessionToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :study_session_id, :integer
  end

  def self.down
    remove_column :activities, :study_session_id
  end
end
