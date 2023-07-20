class Deck < ActiveRecord::Base
  
  module Visibility
    Public = "public"
    Private = "private"
  end
  
  # strip html from fields
  # http://railspikes.com/tags/plugins
  xss_terminate :html5lib_sanitize => [:name, :description, :instruction]
  
  # associations
  belongs_to :user
  # dependent
  has_many :cards, :dependent => :destroy
  has_many :curriculums, :dependent => :destroy
  has_many :activities, :dependent => :destroy
  # distantly related
  has_many :ruminations, :through => :cards
  has_many :users, :through => :curriculums, :order => "login ASC"
  has_many :messages, :dependent => :destroy, :order => "created_at DESC"
  
  # validates whether the associated object or objects are all valid themselves.
  validates_associated  :cards
  # field validation
  validates_presence_of :name, :description, :visibility
  validates_length_of   :name, :within => 1..255, :allow_blank=>true
  validates_inclusion_of :visibility, :in => [Visibility::Public,  Visibility::Private]
  validates_length_of   :instruction, :within => 0..255, :allow_blank=>true
  
  # mass assignment protection for attributes
  attr_accessible :name, :description, :instruction
  
  # named scopes
  named_scope :public_visibility, :conditions => ["visibility=?", "public"]
  named_scope :recent, :conditions => ["visibility=?", Visibility::Public], :order=>"created_at DESC"
  named_scope :byname, :conditions => ["visibility=?", Visibility::Public], :order=>"name ASC"  

  named_scope :hot, lambda {
    { :select => 'decks.*, COUNT(curriculums.id) curriculums_count',
      :conditions => ["date(decks.created_at) > date(?) and visibility=?",(Date.today-30),Visibility::Public],
      :joins => :curriculums, :order => 'curriculums_count DESC', :group => "decks.id"} }

  named_scope :popular, 
    :select => 'decks.*, COUNT(curriculums.id) curriculums_count',
    :conditions => ["visibility=?", Visibility::Public],
    :joins => :curriculums, :order => 'curriculums_count DESC', :group => "decks.id"




  # clone this deck for the given user 
  def user_clone(user)
    return nil if !self.is_public?
    cdeck = clone
    cdeck.id = nil
    cdeck.user = user
    cdeck.created_at = Time.now
    # copy all cards  
    self.cards.each do |card|
      ccard = card.clone
      ccard.id = nil
      ccard.created_at = Time.now
      cdeck.cards << ccard
    end
    return cdeck
  end
  
  def default_instruction
    instruction
  end
  
  # calculate the popularity of a deck
  def popularity
    return self.curriculums.count()
  end
  
  def created_string()
    return time_distance_or_time_stamp(created_at, :show_time => true)
  end
  
  # search deck
  def self.search(query, page)
    paginate :page => page,
      :conditions => ['visibility=? and name like ?', Visibility::Public, "%#{query}%"],
      :order => 'name'
  end
  
  def is_public?
    return visibility == Visibility::Public
  end
  
  def is_author?(a_user)
    return false if a_user.nil?
    return self.user == a_user
  end
  
  def can_edit?(a_user)
    is_author?(a_user)
  end
  
  def is_visible?(a_user)
    return true if self.is_public?
    # we know its private or something not public
    # assume no visability unless author
    return self.is_author?(a_user)
  end
  
  # pagination
  def self.per_page
    10
  end
  
  def self.default_about_deck
     @about_deck = User.find_by_login(DEFAULT_USER_NAME).decks.find_by_name(DEFAULT_DECK_ABOUT)
  end
 
end
