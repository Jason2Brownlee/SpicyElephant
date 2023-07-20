class CreateStudySessions < ActiveRecord::Migration
  def self.up
    create_table :study_sessions do |t|
      t.references :user, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :study_sessions
  end
end
