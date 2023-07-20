class UpdateResultNames < ActiveRecord::Migration
  def self.up
    r = RuminationResult.find(1)
    if r.nil?
      print "Unable to update Rumunation result 1"
    else
      r.name = "Perfect"
      r.description = "Perfect response"
      r.save!
      print "updated rumunation result: #{r.name}\n"
    end
    
    r = RuminationResult.find(2)
    if r.nil?
      print "Unable to update Rumunation result 2"
    else
      r.name = "Good"
      r.description = "Correct response after a hesitation"
      r.save!
      print "updated rumunation result: #{r.name}\n"
    end
    
    r = RuminationResult.find(3)
    if r.nil?
      print "Unable to update Rumunation result 3"
    else
      r.name = "Pass"
      r.description = "Correct response recalled with serious difficulty"
      r.save!
      print "updated rumunation result: #{r.name}\n"
    end
    
    r = RuminationResult.find(4)
    if r.nil?
      print "Unable to update Rumunation result 4"
    else
      r.name = "Fail"
      r.description = "Incorrect response; where the correct one seemed easy to recall"
      r.save!
      print "updated rumunation result: #{r.name}\n"
    end
    
    r = RuminationResult.find(5)
    if r.nil?
      print "Unable to update Rumunation result 5"
    else
      r.name = "Bad"
      r.description = "Incorrect response; the correct one remembered"
      r.save!
      print "updated rumunation result: #{r.name}\n"
    end
    
    r = RuminationResult.find(6)
    if r.nil?
      print "Unable to update Rumunation result 6"
    else
      r.name = "Unknown"
      r.description = "Complete blackout"
      r.save!
      print "updated rumunation result: #{r.name}\n"
    end
    
  end

  def self.down
  end
end
