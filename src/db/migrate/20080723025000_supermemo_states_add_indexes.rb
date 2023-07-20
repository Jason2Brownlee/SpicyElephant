class SupermemoStatesAddIndexes < ActiveRecord::Migration
  def self.up
    add_index :supermemo_states, :card_id
    add_index :supermemo_states, :user_id
    add_index :supermemo_states, :rumination_id
  end

  def self.down
    remove_index :supermemo_states, :card_id
    remove_index :supermemo_states, :user_id
    remove_index :supermemo_states, :rumination_id
  end
end
