class CreateStudyModes < ActiveRecord::Migration
  def self.up
    create_table :study_modes do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :study_modes
  end
end
