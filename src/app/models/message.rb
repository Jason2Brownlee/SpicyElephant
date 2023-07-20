class Message < ActiveRecord::Base

    fields do
      message :text, :required
      timestamps
    end
    
  # associations
  belongs_to :deck
  belongs_to :user
  
    # returns message created on decks authored by the given user and created after x days from now
  def self.find_for_deck_author_created_after(user, days)
    find :all, :conditions => ['user_id = ? and created_at >= date_sub(now(), INTERVAL ? DAY)', user.id, days]
  end
  
end
