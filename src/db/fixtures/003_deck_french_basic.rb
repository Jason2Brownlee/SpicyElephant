
# taken from flashcard db

user = User.find_by_login("jasonb")

# only add if user is found
if(user != nil)
  deck_name = "Common French to English"
  # prevent duplication of the deck data
  if user.decks.find_by_name(deck_name) == nil
    # create the deck
    deck = Deck.create(:name => deck_name, :description => "Common french phrases and their English translation.", :user_id => user.id)
    # create the cards
    Card.create(:deck_id => deck.id, :question => "Bonjour", :answer => "Hello")
    Card.create(:deck_id => deck.id, :question => "Salut", :answer => "Hello")
    Card.create(:deck_id => deck.id, :question => "Ca Va?", :answer => "How are you?")
    Card.create(:deck_id => deck.id, :question => "Oui, ca va bien", :answer => "I'm well")
    Card.create(:deck_id => deck.id, :question => "Pas mal", :answer => "not bad")
    Card.create(:deck_id => deck.id, :question => "Comme ci, comme ca", :answer => "So-so")
    Card.create(:deck_id => deck.id, :question => "Mal", :answer => "Bad")
    Card.create(:deck_id => deck.id, :question => "Au revoir", :answer => "Good-bye")
    Card.create(:deck_id => deck.id, :question => "A bientot", :answer => "See you soon")
    Card.create(:deck_id => deck.id, :question => "A tout a l'heure", :answer => "See you in a bit")
  
    Card.create(:deck_id => deck.id, :question => "A demain", :answer => "See you tomorrow")
    Card.create(:deck_id => deck.id, :question => "Je m'appelle...", :answer => "My name is...")
    Card.create(:deck_id => deck.id, :question => "Commet vous appelez-vous?", :answer => "what's your name?")
    Card.create(:deck_id => deck.id, :question => "Je vous presente", :answer => "This is...")
    Card.create(:deck_id => deck.id, :question => "Enchante(e)", :answer => "Pleased to meet you")
    
    print "Created deck: #{deck_name}, by user #{user.login}\n"
  end
end