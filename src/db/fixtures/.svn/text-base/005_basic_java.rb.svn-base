
# taken from flashcard db

user = User.find_by_login("craig")

# only add if user is found
if(user != nil)
  deck_name = "Basic Java Vocab"
  # prevent duplication of the deck data
  if user.decks.find_by_name(deck_name) == nil
    # create the deck
    deck = Deck.create(:name => deck_name, :description => "A series of basic java terms and phrases and their definition.", :user_id => user.id)
    # create the cards
    Card.create(:question => "Linear Search", :answer => "This is a very straightforward loop comparing every element in the array with the key. As soon as an equal value is found, it returns. If the loop finishes without finding a match, the search failed and -1 is returned.", :deck_id => deck.id)
    Card.create(:question => "Binary Search", :answer => "A fast way to search a sorted array is to use a binary search. The idea is to look at the element in the middle. If the key is equal to that, the search is finished. If the key is less than the middle element, do a binary search on the first half. If it's", :deck_id => deck.id)
    Card.create(:question => "Exception", :answer => "indication of a problem that occurs during execution", :deck_id => deck.id)
    Card.create(:question => "Exception handling", :answer => "allows the program to continue executing the code", :deck_id => deck.id)
    Card.create(:question => "Java API", :answer => "lists exceptions thrown by each method", :deck_id => deck.id)
    Card.create(:question => "java.lang.Exception", :answer => "All exceptions extend this class", :deck_id => deck.id)
    Card.create(:question => "Boolean", :answer => "T/F - logical expressions evaluate to this", :deck_id => deck.id)
    Card.create(:question => "Sentinel Controlled Loop", :answer => "uses a special value to determine when it should terminate repetition", :deck_id => deck.id)
    Card.create(:question => "Objects", :answer => "Have attributes and behaviours", :deck_id => deck.id)
    
    Card.create(:question => "Inheritance", :answer => "a relationship between two classes where a class absorbs characteristics of a previously defined class as well as adding its own attributes and behaviours", :deck_id => deck.id)
    Card.create(:question => "UML", :answer => "Unified Modeling Language", :deck_id => deck.id)
    Card.create(:question => "Modularization", :answer => "divide-and-conquer approach to problem solving. more software reusibility", :deck_id => deck.id)
    Card.create(:question => "Static Methods", :answer => "Do not require an object to perform task", :deck_id => deck.id)
    Card.create(:question => "The Principle of Least Priviledge", :answer => "Code should only have the amount of access as it needs to complete the task", :deck_id => deck.id)    
     
    print "Created deck: #{deck_name}, by user #{user.login}\n"
  end
end