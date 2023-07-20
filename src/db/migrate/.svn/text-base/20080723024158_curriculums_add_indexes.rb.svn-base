class CurriculumsAddIndexes < ActiveRecord::Migration
  def self.up
    add_index :curriculums, :deck_id
    add_index :curriculums, :user_id
  end

  def self.down
    remove_index :curriculums, :deck_id
    remove_index :curriculums, :user_id
  end
end
