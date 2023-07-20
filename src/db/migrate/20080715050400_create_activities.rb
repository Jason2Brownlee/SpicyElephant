class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string :name, :null => false
      t.text :note
      t.references :user
      t.references :deck

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
