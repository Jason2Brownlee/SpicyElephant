class Activity < ActiveRecord::Base

  # associations
  belongs_to :deck
  belongs_to :user
  belongs_to :study_session
  has_many :ruminations, :through => :study_session

  # named scopes
  named_scope :recent, :order=>"created_at DESC"
  
  # def self.recent(limit=10)
  #   return Activity.find(:all, :order => "created_at DESC", :limit => limit)
  # end
  
  # format: <user.login> <description> <deck.name>(if available) <created_at>


  def self.user_created_deck(user, deck)
    activity = Activity.new
    activity.user = user
    activity.deck = deck
    activity.name = "created_deck"
    activity.note = "created deck"
    # no protection or checking if it worked
    activity.save
  end
  
  def self.user_added_deck_to_curriculum(user, deck)
    activity = Activity.new
    activity.user = user
    activity.deck = deck
    activity.name = "added_deck"
    activity.note = "decided to study deck"
    # no protection or checking if it worked
    activity.save
  end
  
  def self.user_recommend_deck(user, deck)
    activity = Activity.new
    activity.user = user
    activity.deck = deck
    activity.name = "recommended_deck"
    activity.note = "recommended a deck to a friend"
    # no protection or checking if it worked
    activity.save
  end
  
  def self.user_messaged_deck(user, deck)
    activity = Activity.new
    activity.user = user
    activity.deck = deck
    activity.name = "messaged_deck"
    activity.note = "left a message on deck"
    # no protection or checking if it worked
    activity.save
  end
end
