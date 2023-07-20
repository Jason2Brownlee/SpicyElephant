require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password
  
  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 6..100
  validates_format_of       :email,
                            :with => %r{\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z}i, 
                            :message => "should be like xxx@yyy.zzz"
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :identity_url, :time_zone, :notification_enabled
  
  
  
  # associations
  belongs_to :study_mode
  # many
  has_many :permissions, :dependent => :destroy
  has_many :decks, :dependent => :destroy, :order => "name ASC"
  has_many :curriculums, :dependent => :destroy
  
  has_many :subscribed_decks, :through => :curriculums, :source => 'deck'  
  has_many :study_sessions, :dependent => :destroy
  has_many :supermemo_states, :dependent => :destroy
  has_many :activities, :dependent => :destroy, :order => "created_at DESC"
  has_many :messages
  has_many :subscriptions
  # through
  has_many :roles, :through => :permissions
  has_many :ruminations, :through => :study_sessions
  
  # additional awesome associations
  has_many :supermemo_study_sessions, :class_name=>"StudySession", :conditions => ["study_mode_id=3"]
  has_many :supermemo_ruminations, :through => :supermemo_study_sessions, :source => :ruminations
  has_many :review_study_sessions, :class_name=>"StudySession", :conditions => ["study_mode_id=1"]
  has_many :review_ruminations, :through => :review_study_sessions, :source => :ruminations
  
  has_many :curriculum_decks, :through => :curriculums, :source => :deck
  
  has_many :authored_decks, :class_name=>"Deck", :order => "name ASC"
  has_many :authored_cards, :through => :authored_decks, :source => :cards
  has_many :current_supermemo_ruminations, :through => :supermemo_states, :source => :rumination
  has_many :supermemo_positive_retention, :through => :supermemo_states, :source => :rumination, :conditions => ["rumination_result_id<=3"]
  has_many :supermemo_negative_retention, :through => :supermemo_states, :source => :rumination, :conditions => ["rumination_result_id>3"]


  before_save :encrypt_password
  before_create :make_activation_code



  # limit to 100 per request to prevent gmail send overload
  def self.send_notifications()
    # only get users with notifications enabled
    puts "Running user send notifications job..."
    users = User.find_notifiabled(7, 400)
    for user in users
      begin
        cr = user.study_mode.count_review_user(user)
        #ct = user.total_cards
        # find new message since last login
        mc = Message.find_for_deck_author_created_after(user, 7).size
        # only send the message if new message or scheduled cards
        if (cr > 0 || mc > 0) 
          UserMailer::deliver_scheduled_notification(user, cr, mc)
        end
        user.update_last_notification
      rescue
        # .. handle error
      end 
    end
  end
  
  # returns user who have notifications enabled and have not logged in for the past ? days
  def self.find_notifiabled(days, limit)
    find :all, :conditions => ['notification_enabled = 1 and enabled = 1 and activated_at is not null
                                and date(coalesce( last_signin_at, created_at)) <= date_sub(now(), INTERVAL ? DAY)
                                and date(coalesce( last_notification_email_at, date_sub(curdate(), INTERVAL 30 DAY))) <= date_sub(now(), INTERVAL ? DAY)', days, days],
               :limit => limit
  end
  
  def update_last_notification
    self.last_notification_email_at = Time.now.utc
    save(false)
  end
  
  def update_last_signin_at
    self.last_signin_at = Time.now.utc
    save(false)
  end

  def humanized_name
    return self.login
  end
  
  def total_cards
    supermemo_states.count
  end
  
  def cards_remaining(deck = nil)
    return SupermemoState.count_review_user(self, deck, Time.zone.today)
  end
  
  # only most recent results (from supermemo)
  def count_supermemo_positive_retention(deck=nil)
    return supermemo_positive_retention.count() if deck.nil?
    return supermemo_positive_retention.count(:all, :conditions => ["cards.deck_id=?",deck.id], :include => :card)
  end 
  
  # only most recent results (from supermemo)
  def count_supermemo_negative_retention(deck=nil)
    return supermemo_negative_retention.count() if deck.nil?
    return supermemo_negative_retention.count(:all, :conditions => ["cards.deck_id=?",deck.id], :include => :card)
  end
  
  # all results in supermemo training (not just most recent)
  def count_rumination_result_by_type(type, deck=nil)
    return supermemo_ruminations.count(:all, :conditions => ["rumination_result_id=?", type.id]) if deck.nil?
    return supermemo_ruminations.count(:all, :conditions => ["rumination_result_id=? and cards.deck_id=?", type.id, deck.id], :include => :card)
  end
  
  def retention_percentage(deck=nil)
    # only want studied %, not absolute (cards) % 
    pos = count_supermemo_positive_retention(deck)
    neg = count_supermemo_negative_retention(deck)
    total = (pos + neg)
    return 0.0 if total == 0
    per = (pos.to_f/total.to_f)*100.0
    return per.round(2)
  end
  
  # date that this user last studied (most recently) the provided deck, nil if never
  def date_last_studied(deck)
    rum = ruminations.find(:first, 
      :conditions => ["cards.deck_id=?", deck.id], 
      :include => :card,
      :order => "ruminations.created_at DESC")
    
    return nil if rum.nil?
    return rum.created_at
  end
  
  # Activates the user in the database.
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end
  
  # Finds the user with the corresponding activation code, activates their account and returns the user.
  #
  # Raises:
  #  +User::ActivationCodeNotFound+ if there is no user with the corresponding activation code
  #  +User::AlreadyActivated+ if the user with the corresponding activation code has already activated their account
  def self.find_and_activate!(activation_code)
    raise ArgumentError if activation_code.nil?
    user = find_by_activation_code(activation_code)
    raise ActivationCodeNotFound if !user
    raise AlreadyActivated.new(user) if user.active?
    user.send(:activate!)
    user
  end
  
  
  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  def self.email_authenticate(email, password)
    u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end
  
  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end
  
  def authenticated?(password)
    crypted_password == encrypt(password)
  end
  
  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end
  
  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 4.weeks
  end
  
  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end
  
  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end
  
  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end
  
  def reset_password
    # First update the password_reset_code before setting the
    # reset_password flag to avoid duplicate email notifications.
    update_attribute(:password_reset_code, nil)
    @reset_password = true
  end  
  
  #used in user_observer
  def recently_forgot_password?
    @forgotten_password
  end
  
  def recently_reset_password?
    @reset_password
  end
  
  def self.find_for_forget(email)
    find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email]
  end
  
  def has_role?(rolename)
    self.roles.find_by_rolename(rolename) ? true : false
  end
  
  def has_administrator_role?
    has_role?('administrator')
  end
  
  def has_subscribed_role?
     return has_role?('subscribed')
  end
  
  def can_add_to_curriculum?
    return false if (!has_subscribed_role? and curriculums.count>=FREEMIUM_TOTAL_DECKS)
    return true
  end
  
  def self.count_subscribed_users
    return User.count(:all, :conditions=>["roles.rolename=?","subscribed"],:include=>:roles)
  end
  
  def self.count_paid_subscribed_users
    return Subscription.count(:all)
  end
  
  # magic for adding a deck to a curriculum
  # don't fuck with this unless you know things 
  def add_deck_to_curriculum?(deck)
    if !deck.is_visible?(self)
      errors.add_to_base 'Sorry, you do not have permission to study this deck.'
      return false
    elsif Curriculum.deck_in_user_curriculum?(self, deck)
      errors.add_to_base 'Unable to add to curriculum, already added.'
      return false
    elsif !can_add_to_curriculum?
      errors.add_to_base 'Unable to add to curriculum, please subscribe to add more decks.'
      return false
    else 
      curriculum = self.curriculums.build(:deck => deck)
      return curriculum.save
    end
  end
  
  protected
  # before filter 
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end
  
  def password_required?
      not_openid? && (crypted_password.blank? || !password.blank?)
 end
 
  def not_openid?
    identity_url.blank?
   end

  def make_activation_code
    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
  
  def make_password_reset_code
      self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
  
    def activate!
      @activated = true
      self.update_attribute(:activated_at, Time.now.utc)
    end 
  
end
