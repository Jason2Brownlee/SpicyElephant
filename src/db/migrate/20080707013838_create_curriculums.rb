class CreateCurriculums < ActiveRecord::Migration
  def self.up
    create_table :curriculums do |t|
      t.references :user
      t.references :deck

      t.timestamps
    end
  end

  def self.down
    drop_table :curriculums
  end
end
