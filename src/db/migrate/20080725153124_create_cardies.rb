class CreateCardies < ActiveRecord::Migration
  def self.up
    create_table :cardies do |t|
      t.string :super
      t.string :thing

      t.timestamps
    end
  end

  def self.down
    drop_table :cardies
  end
end
