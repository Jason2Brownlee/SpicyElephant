class AddingSupermemoState < ActiveRecord::Migration
  def self.up
    create_table :supermemo_states do |t|
      t.date     :train_date
      t.float    :interval, :default => 0
      t.float    :easiness_factor, :default => 2.5
      t.integer  :repitions, :default => 0
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :card_id
      t.integer  :user_id
    end
    
  end

  def self.down   
    drop_table :supermemo_states
  end
end
