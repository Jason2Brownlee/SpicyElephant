class AddStudy < ActiveRecord::Migration
  def self.up
    add_column :ruminations, :study_session_id, :integer, :null => false
    remove_column :ruminations, :user_id
  end

  def self.down
    remove_column :ruminations, :study_session_id
    add_column :ruminations, :user_id, :integer
  end
end
