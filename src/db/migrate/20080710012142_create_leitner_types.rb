class CreateLeitnerTypes < ActiveRecord::Migration
  def self.up
    create_table :leitner_types do |t|
      t.string :name
      t.text :description
      t.integer :spacing

      t.timestamps
    end
  end

  def self.down
    drop_table :leitner_types
  end
end
