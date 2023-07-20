class UpgradeAllUsersToSupermemo < ActiveRecord::Migration
  def self.up
    for user in User.find(:all)
      user.study_mode = StudyMode.supermemo_mode
      #user.update_attributes(:study_mode => StudyMode.supermemo_mode)
      user.save!
    end
  end

  def self.down
  end
end
