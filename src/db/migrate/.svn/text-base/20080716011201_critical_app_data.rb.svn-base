class CriticalAppData < ActiveRecord::Migration
  def self.up
    if StudyMode.find_by_name('review') == nil
      lt = StudyMode.create(:name => 'review', :description => 'Review cards in an end-to-end manner')
      print "Created StudyMode: #{lt.name}\n"
    end

    if StudyMode.find_by_name('supermemo') == nil
      lt = StudyMode.create(:name => 'supermemo', :description => 'Review cards according to the Supermemo System (V2)')
      print "Created StudyMode: #{lt.name}\n"
    end
    

  end

  def self.down
  end
end
