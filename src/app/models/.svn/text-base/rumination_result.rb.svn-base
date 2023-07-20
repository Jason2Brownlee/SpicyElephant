class RuminationResult < ActiveRecord::Base
  fields do
    name :string
    description :text
  end
  
  
  # only result types approporiate to the leitner system
  def self.passfail_results
    return RuminationResult.find(:all, 
      :conditions => "id between 3 and 4",
      :order => 'id')
  end
  
  # all result types
  def self.all_results
    return RuminationResult.find(:all, :order => 'id')
  end
  
  def is_pass?
    return id<= 3
  end
  
  def is_fail?
    return id>3
  end
  
end
