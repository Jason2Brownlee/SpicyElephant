class Rumination < ActiveRecord::Base
  #RumenOutcome = HoboFields::EnumString.for(:bright, :good, :pass, :fail, :null)
  fields do
    timestamps
  end

  # associations
  belongs_to :rumination_result
  belongs_to :card
  belongs_to :study_session
  has_many :supermemo_states

  # validation
  validates_presence_of :card, :rumination_result, :study_session

  # count user/card
  def self.count_user_card_ruminations(user, card)
    return Rumination.count(:conditions => ["study_sessions.user_id=? and card_id=?",
      user.id, card.id],
      :include => :study_session)
  end
  
  # most recent rumination for user/deck
  def self.rumination_user_last_studied_deck(user, deck)
    return Rumination.find(:first, 
    :conditions => ["study_sessions.user_id=? and cards.deck_id=?", user.id, deck.id],
    :order => "ruminations.created_at DESC", 
    :include => [:study_session, :card])
  end

end
