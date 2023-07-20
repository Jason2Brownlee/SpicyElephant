
# taken from flashcard db

user = User.find_by_login("craig")

# only add if user is found
if(user != nil)
  deck_name = "World Flags"
  # prevent duplication of the deck data
  if user.decks.find_by_name(deck_name) == nil
    # create the deck
    deck = Deck.create(:name => deck_name, :description => "Images of world flags and there respective countries", :user_id => user.id)
    # create the cards
    Card.create(:question => "<img src=\"http://www.flags.net/images/smallflags/AFGH0001.GIF\"/>", :answer => "Afghanistan", :deck_id => deck.id)
    Card.create(:question => "<img src=\"http://www.flags.net/images/smallflags/OAUN0001.GIF\"/>", :answer => "African Union", :deck_id => deck.id)
    Card.create(:question => "<img src=\"http://www.flags.net/images/smallflags/ALBA0001.GIF\"/>", :answer => "Albania", :deck_id => deck.id)
    Card.create(:question => "<img src=\"http://www.flags.net/images/smallflags/ALDE0001.GIF\"/>", :answer => "Alderney", :deck_id => deck.id)
    Card.create(:question => "<img src=\"http://www.flags.net/images/smallflags/ALGE0001.GIF\"/>", :answer => "Algeria", :deck_id => deck.id)
    Card.create(:question => "<img src=\"http://www.flags.net/images/smallflags/UNST0001.GIF\"/>", :answer => "America (see United States)", :deck_id => deck.id)
    Card.create(:question => "<img src=\"http://www.flags.net/images/smallflags/AMSA0001.GIF\"/>", :answer => "American Samoa", :deck_id => deck.id)
    Card.create(:question => "<img src=\"http://www.flags.net/images/smallflags/ANDR0001.GIF\"/>", :answer => "Andorra", :deck_id => deck.id)
    Card.create(:question => "<img src=\"http://www.flags.net/images/smallflags/AGLA0001.GIF\"/>", :answer => "Angola", :deck_id => deck.id)
    Card.create(:question => "<img src=\"http://www.flags.net/images/smallflags/ANGU0001.GIF\"/>", :answer => "Anguilla", :deck_id => deck.id)
    Card.create(:question => "<img src=\"http://www.flags.net/images/smallflags/ANTA0001.GIF\"/>", :answer => "Antarctica", :deck_id => deck.id)
    Card.create(:question => "<img src=\"http://www.flags.net/images/smallflags/ANBA0001.GIF\"/>", :answer => "Antigua & Barbuda", :deck_id => deck.id)
    Card.create(:question => "<img src=\"http://www.flags.net/images/smallflags/ARLE0001.GIF\"/>", :answer => "Arab League", :deck_id => deck.id)
     
    print "Created deck: #{deck_name}, by user #{user.login}\n"
  end
end