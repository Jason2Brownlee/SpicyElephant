class FixUserStudymodeDeath < ActiveRecord::Migration
  def self.up
    change_column :users, :study_mode_id, :integer, :default => 3
  end

  def self.down
  end
end
