class DropLeitner < ActiveRecord::Migration
  def self.up
    drop_table :leitner_states
    drop_table :leitner_types
  end

  def self.down
  end
end
