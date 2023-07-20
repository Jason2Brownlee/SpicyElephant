class AllowNullUserInStudySessions < ActiveRecord::Migration
  def self.up
    change_column :study_sessions, :user_id, :integer, :null => true
    add_column :study_sessions, :deck_id, :integer, :null => true
  end

  def self.down
    change_column :study_sessions, :user_id, :integer, :null => false
    remove_column :study_sessions, :deck_id
  end
end
