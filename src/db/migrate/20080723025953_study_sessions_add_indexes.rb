class StudySessionsAddIndexes < ActiveRecord::Migration
  def self.up
    add_index :study_sessions, :user_id
    add_index :study_sessions, :deck_id
  end

  def self.down
    remove_index :study_sessions, :user_id
    remove_index :study_sessions, :deck_id
  end
end
