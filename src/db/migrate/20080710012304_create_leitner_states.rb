class CreateLeitnerStates < ActiveRecord::Migration
  def self.up
    create_table :leitner_states do |t|
      t.references :leitner_type
      t.references :card
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :leitner_states
  end
end
