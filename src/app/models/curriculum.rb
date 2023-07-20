class Curriculum < ActiveRecord::Base
  
  # associations
  belongs_to :user
  belongs_to :deck
  
  def self.deck_in_user_curriculum?(user, deck)
    return Curriculum.exists?(:deck_id => deck.id, :user_id => user.id)
  end
  
  # the total number of entries for a users decks in curriculums
  # a rough mass popularity measure
  def self.count_sum_popularity(user)
    return Curriculum.count(:all,
           :conditions => ["decks.user_id=?", user.id],
           :include => :deck)
  end
end
