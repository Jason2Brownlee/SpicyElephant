class UpdateSupermemoStatesRenameRepititionsToRepetitions < ActiveRecord::Migration   
  def self.up  
    rename_column :supermemo_states, :repitions, :repetition
    change_column :supermemo_states, :repetition, :integer, :default => 0
  end

  def self.down
    change_column :supermemo_states, :user_id, :integer, :limit => 11
    change_column :supermemo_states, :repitions, :integer, :limit => 11, :default => 0
  end
end
