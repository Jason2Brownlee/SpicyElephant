class ChangeColumnOnUser < ActiveRecord::Migration
  def self.up
    rename_column :users, :preferred_study_mode_id, :study_mode_id
  end

  def self.down
    rename_column :users, :study_mode_id, :preferred_study_mode_id
  end
end
