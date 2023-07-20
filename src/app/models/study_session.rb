class StudySession < ActiveRecord::Base
  
  
  # associations
  has_many :ruminations, :dependent => :destroy
  has_many :activity, :dependent => :destroy
  has_many :studied_cards, :through => :ruminations, :source => 'card'
  
  belongs_to :study_mode
  belongs_to :user
  
  belongs_to :deck
  
  has_many :un
  
  # validation
  validates_presence_of :study_mode
  
  # update result for card on this session
  def submit_result(card, result)
    # always create the rumination
    rumination = ruminations.create!(:card => card, :rumination_result => result)
    # only update scheduled states if not review mode
    # when we do, we update for all algorithms - so we can switch
    if !self.study_mode.is_review?
      # retrieve the current supermemo state
      s_state = self.user.supermemo_states.find(:first, :conditions => ["card_id=?", card.id])
      # update the supermemo state
      s_state.update_state!(result, rumination)
    end
  end
  
  def count_positive_results
    return self.ruminations.count(:all, :conditions => "ruminations.rumination_result_id <= 3")
  end
  
  def count_negative_results
    return self.ruminations.count(:all, :conditions => "ruminations.rumination_result_id > 3")
  end
  
  def count_results_by_type(type)
    return self.ruminations.count(:conditions => ["ruminations.rumination_result_id=?",type.id])
  end
  
  #def self.session_for_user_deck(user, deck)
  #  return StudySession.find(:first, 
  #  :conditions => ["cards.deck_id=? and study_sessions.user_id=?", deck.id, user.id],
 #   :order => "study_sessions.created_at DESC", :include => :cards)
  #end
  
  
  def finish
    if self.deck.nil?
       Activity.create(:user => self.user, :study_session => self, :name => "trained_scheduled", :note => "studied scheduled cards")  
    else
      verb = self.study_mode.is_review? ? "reviewed" : "studied"
      Activity.create(:user => self.user, :study_session => self, :name => "#{verb}_deck", :note => "#{verb} deck", :deck => self.deck)
    end
  end
  
  def next_card
    if self.study_mode.is_supermemo?
      next_supermemo_card
    else 
      # defaults to review mode for safety
      # safe if deck and/or card is empty
      next_review_card
    end
  end
  
  def next_cards
    if self.study_mode.is_supermemo?
      next_supermemo_cards
    else 
      # defaults to review mode for safety
      # safe if deck and/or card is empty
      next_review_cards
    end
  end
  
  def next_supermemo_card
    find_supermemo_cards(:first)
  end
  
  def find_supermemo_cards(one_or_many = :first)
     con = "supermemo_states.user_id=#{user.id}"
     con += " and deck_id=#{deck.id}" unless self.deck.nil?
     return Card.find(one_or_many, 
       :conditions => ["#{con} and date(train_date) <= date(?)", Time.zone.today],
       :order => "RAND()", 
       :include => :supermemo_states)
   end
   
  def next_supermemo_cards
    find_supermemo_cards(:all)
  end
  
  # return the next card for review for a user/deck
  # return the next card for review in the user's curriculum if deck is nil
  # cheating, by only looking in the supermemo_states table 
  
  def next_review_card
    find_review_cards(:first)
  end
  
  def next_review_cards
    find_review_cards(:all)
  end
  
  def find_review_cards(one_or_many = :first)
    if studied_cards.size > 0
      deck.cards.find(one_or_many, 
        :conditions => "id NOT IN (#{studied_cards.*.id.join(',')})",
        :order => "RAND()")
    else
      deck.cards.find(one_or_many, :order => "RAND()")
    end
  end
    
  
  def cards_remaining
    return SupermemoState.count_review_user(self.user, self.deck, Time.zone.today) if self.study_mode.is_supermemo?
    return review_cards_remaining if self.study_mode.is_review?
  end
    
  def review_cards_remaining
    self.deck.cards.count - self.studied_cards.count
  end
  
end

