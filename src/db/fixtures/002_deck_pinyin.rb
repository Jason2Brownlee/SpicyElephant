
# taken from flashcard db

user = User.find_by_login("jasonb")

# only add if user is found
if(user != nil)
  deck_name = "Chinese Pinyin to English"
  if user.decks.find_by_name(deck_name) == nil
    # create the deck
    deck = Deck.create(:name => deck_name, :description => "Common phrases in Chinese pinyin and their English translation.", :user_id => user.id)
    # create the cards
    Card.create(:deck_id => deck.id, :question => "Nǐ hǎo", :answer => "hello")
    Card.create(:deck_id => deck.id, :question => "Wǒ jiào Vince", :answer => "I'm Vince")
    Card.create(:deck_id => deck.id, :question => "wǒ", :answer => "I/Me")
    Card.create(:deck_id => deck.id, :question => "wǒmen", :answer => "we/us")
    Card.create(:deck_id => deck.id, :question => "guó", :answer => "country")
    Card.create(:deck_id => deck.id, :question => "nǐmen", :answer => "you (pl.)")
    Card.create(:deck_id => deck.id, :question => "shénme", :answer => "what")
    Card.create(:deck_id => deck.id, :question => "nǐ", :answer => "you (sing.)")
    Card.create(:deck_id => deck.id, :question => "tāmen", :answer => "they/them")
    Card.create(:deck_id => deck.id, :question => "míngzi", :answer => "name")
  
    Card.create(:deck_id => deck.id, :question => "shì", :answer => "to be")
    Card.create(:deck_id => deck.id, :question => "Yīngguó", :answer => "Britain")
    Card.create(:deck_id => deck.id, :question => "Zhōngguó", :answer => "China")
    Card.create(:deck_id => deck.id, :question => "yī", :answer => "one")
    Card.create(:deck_id => deck.id, :question => "èr", :answer => "two")
    Card.create(:deck_id => deck.id, :question => "sān", :answer => "three")
    Card.create(:deck_id => deck.id, :question => "sì", :answer => "four")
    Card.create(:deck_id => deck.id, :question => "wǔ", :answer => "five")
    Card.create(:deck_id => deck.id, :question => "shí", :answer => "ten")
    Card.create(:deck_id => deck.id, :question => "shūběn", :answer => "book")
  
    Card.create(:deck_id => deck.id, :question => "rén", :answer => "person/people")
    Card.create(:deck_id => deck.id, :question => "xuéshēng", :answer => "student")
    Card.create(:deck_id => deck.id, :question => "zhè", :answer => "this")
    Card.create(:deck_id => deck.id, :question => "bàozhī", :answer => "newspaper")
    Card.create(:deck_id => deck.id, :question => "hǎo", :answer => "good")
    Card.create(:deck_id => deck.id, :question => "dànshì", :answer => "but/however")
    Card.create(:deck_id => deck.id, :question => "wèishénme", :answer => "why")
    Card.create(:deck_id => deck.id, :question => "yīnwèi", :answer => "because")
    Card.create(:deck_id => deck.id, :question => "bù", :answer => "no")
    
    print "Created deck: #{deck_name}, by user #{user.login}\n"
  end
end