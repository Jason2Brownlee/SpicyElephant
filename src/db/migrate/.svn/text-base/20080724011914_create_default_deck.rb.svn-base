class CreateDefaultDeck < ActiveRecord::Migration
  def self.up
    
    # delete the default admin account - conflicts with spicy
    admin = User.find_by_login("admin")
    admin.destroy if !admin.nil?
    
    # prepare an administrator role
    if Role.find_by_rolename('administrator') == nil
      Role.create(:rolename => 'administrator')
    end

    # function for creating users safely
    def self.create_user(name_s, pass_s, email_s, role_s = nil)
      if User.find_by_login(name_s) == nil
        user = User.new
        user.login = name_s
        user.email = email_s
        user.password = pass_s
        user.password_confirmation = pass_s
       # user.study_mode_id = 3
        user.save
        user.send(:activate!)
        print " > created user #{name_s}\n"
        if(role_s != nil)
          role = Role.find_by_rolename(role_s)
          user = User.find_by_login(name_s)
          permission = Permission.new
          permission.role = role
          permission.user = user
          permission.save
          print " > assigned role #{role_s} to user #{name_s}\n"
        end
      else
        print " > skipped user #{name_s}, already exists\n"
      end
    end
    
    # create this default user
    create_user("spicyelephant", "mayhemmXOTmz", "support@spicyelephant.com", "administrator")

    # create the default learning deck
    # delete if already there

    user = User.find_by_login("spicyelephant")
    deck_name = "About Spicy Elephant"
    deck = user.decks.find(:first, :conditions => ["name=?", deck_name])
    if !deck.nil?
      "Unable to create default deck"
    else
      deck = user.decks.build
      deck.name = deck_name
      deck.description = "An introduction into SpicyElephant, the quickest way to put stuff in your brain"
      deck.visibility = "public"
      
      card = deck.cards.build
      card.question = "What is SpicyElephant?"
      card.answer = "A study and learning webiste where you tell us what to learn, and our intelligent systems organize when you need to study."

      card = deck.cards.build
      card.question = "Why is intelligent scheduling important?"
      card.answer = "It is proven that if you review material to soon and you waste your time, too late and you have to relearn. Intelligent scheduling is about training at the point of forgetting."

      card = deck.cards.build
      card.question = "How does SpicyElephant you schedule study material?"
      card.answer = "We use a state-of-the-art spaced repetition system called supermemo that profiles your memory and retention, per-card."
      
      card = deck.cards.build
      card.question = "What are Decks? and Cards?"
      card.answer = "A <b>card</b> is a single piece of information you want to learn with a question and an answer. A <b>deck</b> is a collection of cards."

      card = deck.cards.build
      card.question = "Why Question and Answer cards?"
      card.answer = "When information is presented as a question, you must generate an anwser which dramatically improves learning. This effect is called active recall."

      card = deck.cards.build
      card.question = "What is Profile? and Train?"
      card.answer = "The user <b>profile</b> summarizes the decks being studied and created by a user. <b>Train</b> lets you study scheduled material, and review studied decks."

      card = deck.cards.build
      card.question = "What is my Curriculum?"
      card.answer = "The decks you are studying are called your <b>curriculum</b>. It may be comprised of decks you have created and those public decks created by other users."
      
      card = deck.cards.build
      card.question = "How much does it cost?"
      card.answer = "Nothing! As a guest you can view and train on all public decks, although without intelligent scheduling or statistics. Signing up allows you to create an unlimited number of decks, and study upto 5 decks at one time."
      
      card = deck.cards.build
      card.question = "What does the Preimum Account Include?"
      card.answer = "By supporting us in purchasing a premium account, you are able to create private decks that are not accessable to other users, and study an unlimited number of decks at one time."
      
      deck.save!
    end
    
  end

  def self.down
    user = User.find_by_login("spicyelephant")
    deck = user.decks.find(:first, :conditions => ["name=?", "About Spicy Elephant"]) if !user.nil?
    user.destroy if !user.nil?
    deck.destroy if !deck.nil?
  end
end
