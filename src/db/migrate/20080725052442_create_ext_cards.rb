class CreateExtCards < ActiveRecord::Migration
  def self.up
    create_table :ext_cards do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :ext_cards
  end
end
