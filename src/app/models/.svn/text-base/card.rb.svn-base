class Card < ActiveRecord::Base
  
  # strip html from fields
  # http://railspikes.com/tags/plugins
  xss_terminate :html5lib_sanitize => [ :question, :answer, :instruction ]
  
  # associations
  belongs_to :deck
  has_many :ruminations, :dependent => :destroy
  has_many :supermemo_states, :dependent => :destroy
  
  # validation
  validates_presence_of :question, :answer
  validates_length_of   :instruction, :within => 0..255, :allow_blank=>true

  # accessible attributes
  attr_accessible :question, :answer, :instruction
  
  def instruction
    instruction = read_attribute('instruction')
    instruction ||= self.deck.instruction
  end

  def can_edit?(user)
    self.deck.is_author?(user)
  end
end
  
