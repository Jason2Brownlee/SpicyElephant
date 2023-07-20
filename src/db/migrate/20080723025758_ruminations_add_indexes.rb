class RuminationsAddIndexes < ActiveRecord::Migration
  def self.up
    add_index :ruminations, :rumination_result_id
    add_index :ruminations, :card_id
    add_index :ruminations, :study_session_id
  end

  def self.down
    remove_index :ruminations, :rumination_result_id
    remove_index :ruminations, :card_id
    remove_index :ruminations, :study_session_id
  end
end
