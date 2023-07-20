class StudyMode < ActiveRecord::Base
  
  has_many :study_sessions
  has_many :users
  
  
  def self.all_modes
    StudyMode.find(:all, :order => "id ASC") 
  end
  
  def self.supermemo_mode
    StudyMode.find_by_name('supermemo') 
  end
  
  def self.review_mode
    StudyMode.find_by_name('review') 
  end
  
    def is_supermemo?
    name=='supermemo'
  end
  
  def is_review?
    name=='review'
  end
  
  # helper for calculating the number of remaining cards
  def count_review_user(user, deck=nil, current_card=nil, date=Time.zone.today)
    return SupermemoState.count_review_user(user, deck, date) if self.is_supermemo?
    return Card.count_review_user(user, deck, current_card)
  end
  
  

  
#  # total cards in the user's curriculum
#  # all three should return the same number
#  def count_total_user_cards(user, deck=nil, current_card=0)
#    return SupermemoState.count_user(user, deck) if self.is_supermemo?
#    return Card.count_review_user(user, deck, current_card)
#  end  
  
  def user_has_cards_for_review?(user, deck)
    if is_supermemo? then SupermemoState.user_has_cards_for_review?(user, deck)
    else true
    end
  end
end
