class SupermemoState < ActiveRecord::Base
  fields do
    train_date  :date
    interval :float, :default => 0
    easiness_factor :float, :default => 2.5
    repetition :integer, :default => 0
    timestamps
  end
  
  # based on: http://www.supermemo.com/english/ol/sm2.htm
  # step 7 is skipped: 
  # After each repetition session of a given day repeat again all items that scored 
  # below four in the quality assessment. Continue the repetitions until all of
  # these items score at least four.
  
  # associations
  belongs_to :card
  belongs_to :user
  belongs_to :rumination
  
  # validation
  validates_presence_of :user, :card
  
  
  # create base states for user/deck
  def self.initialize_user_deck(user, deck)
    today = Time.zone.today
    # awesome, deadly, mass insert in one line
    ActiveRecord::Base.connection.execute("insert into supermemo_states (user_id, card_id, train_date) " +
      "select #{user.id}, c.id, '#{today}' from cards c where c.deck_id=#{deck.id} and " +
      "c.id not in (select card_id from supermemo_states where user_id=#{user.id})")
  end
  
  # initialize all decks in a user's curriculum
  def self.init(user, deck=nil)
    # fast check to avoid work
    # return if !SupermemoState.user_has_missing_states?(user)
    
    if deck.nil?
      today = Time.zone.today
      # deadly mass insert for all things in curriculum without states
      ActiveRecord::Base.connection.execute("insert into supermemo_states (user_id, card_id, train_date) " +
        "select #{user.id}, c.id, '#{today}' from cards c, curriculums r " +
        "where c.deck_id=r.deck_id and r.user_id=#{user.id} and " +
        "c.id not in (select card_id from supermemo_states where user_id=#{user.id})")
    else
      SupermemoState.initialize_user_deck(user, deck)
    end
  end
  
  # def self.user_has_missing_states?(user)
  #   return true if user.count_curriculum_cards != user.supermemo_states.count
  #   return false
  # end
  
  
  # total cards under the system for a user/deck
  # really only useful for deck/type or user/type calculations
  def self.count_user(user, deck=nil)
    con =  "user_id=#{user.id}"
    con += " and cards.deck_id=#{deck.id}" unless deck.nil?
    return SupermemoState.count(:conditions => con, :include => :card)
  end
  
  # count of cards requiring review for a user/deck/type
  # lots of rails magic to remove conditions if parameters are not provided
  def self.count_review_user(user, deck=nil, date=Time.zone.today)
    con =  "user_id=#{user.id}"
    con += " and cards.deck_id=#{deck.id}" unless deck.nil?
    return SupermemoState.count(:conditions => ["#{con} and date(train_date)<=date(?)", date], 
      :include => :card)
  end
  
  # count of cards requiring review for a user/deck/type
  # lots of rails magic to remove conditions if parameters are not provided
  def self.count_review_user_on_or_between_dates(user, deck=nil, date1=Time.zone.today, date2=nil)
    con =  "user_id=#{user.id}"
    con += " and cards.deck_id=#{deck.id}" unless deck.nil?
    if date2.nil?
      return SupermemoState.count(:conditions => ["#{con} and date(train_date)=date(?)", date1], 
             :include => :card)
    end
    
    return SupermemoState.count(:conditions => ["#{con} and date(train_date) between date(?) and date(?)", 
      date1, date2], :include => :card)
  end
  
  # count of cards not requiring review for a user/deck/type
  def self.count_noreview_user(user, deck=nil)
    con =  "user_id=#{user.id}"
    con += " and cards.deck_id=#{deck.id}" unless deck.nil?
    return SupermemoState.count(:conditions => ["#{con} and date(train_date)>date(?)", Time.zone.today], 
      :include => :card)
  end

  # whether or not there are cards for review for a user/deck/type
  def self.user_has_cards_for_review?(user, deck=nil)
    return SupermemoState.count_review_user(user, deck) > 0
  end
  
  def update_state!(result, rumination)
    # interval must be before easiness_factor
    self.interval = self.next_interval(result)
    self.easiness_factor = self.next_easiness_factor(result)
    self.train_date = Time.zone.today + self.interval
    self.repetition += 1
    self.rumination = rumination
    self.save!
  end
  
  # calculate the next easyness factor
  # result: a ruminations result with id between 1 and 6
  # EF':=EF+(0.1-(5-q)*(0.08+(5-q)*0.02))
  # If EF is less than 1.3 then let EF be 1.3
  def next_easiness_factor(result)
    # -1 because results are stored [1-6], expect [0-5]
    # inverted because in the db we store them good-to-bad, algorithm is unchaged for readability
    q = (result.id - 1)
    q = 5 - q
    ef = self.easiness_factor + (0.1-(5-q)*(0.08+(5-q)*0.02))
    return 1.3 if (ef < 1.3)
    return ef
  end
  
  # called on update to determine the next interval day
  # If the quality response was lower than 3 then start repetitions for the item from the beginning without changing the E-Factor
  def next_interval(result)
    # check for a reset
    return 1 if result.is_fail?
    # n=1
    return 1 if self.repetition==0
    # n=2
    return 6 if self.repetition==1
    # for n>2: I(n):=I(n-1)*EF
    # If interval is a fraction, round it up to the nearest integer
    return (self.interval * self.easiness_factor).round
  end
   
  # total cards in the user's curriculum
  # all three should return the same number
  def count_total_user_cards(user, deck=nil, current_card=0)
    return SupermemoState.count_user(user, deck) if self.is_supermemo?
    return Card.count_review_user(user, deck, current_card)
  end  
  
end