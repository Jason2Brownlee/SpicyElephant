
# taken from flashcard db

user = User.find_by_login("ctaylor")

# only add if user is found
if(user != nil)
  deck_name = "Mathematical vocabulary"
  # prevent duplication of the deck data
  
  if user.decks.find_by_name(deck_name) == nil
    # create the deck
    deck = Deck.find_or_create_by_name(:name => deck_name, :description => "A series of mathematical words and their definitions.", :user_id => user.id)
    # create the cards
    Card.create(:question => "composite number", :answer => "a composite number is an integer greater than 1 with more than two positive factors  	 edit  / delete", :deck_id => deck.id)
    Card.create(:question => "base", :answer => "the base is the repeated factor of a number written in exponential form", :deck_id => deck.id)
    Card.create(:question => "divisible", :answer => "divisible means that the remainder is 0 when you divide one integer by another", :deck_id => deck.id)
    Card.create(:question => "equivalent fractions", :answer => "equilvalent fractions are fractions thatdescribe the same part of a whole", :deck_id => deck.id)
    Card.create(:question => "exponent", :answer => "an exponent is a number that shows how many times a base is used as a factor", :deck_id => deck.id)
    Card.create(:question => "factor", :answer => "a factor of a nonzero number is an integer that divides the nonzero integer with a remainer 0", :deck_id => deck.id)
    Card.create(:question => "greatest common factor (GCF)", :answer => "the greatest common factor of two or more numbers is the greatest factor that the numbers have in common", :deck_id => deck.id)
    Card.create(:question => "power", :answer => "a power is any expression in the exponent form. Power is also used to refer to the exponet", :deck_id => deck.id)
    Card.create(:question => "prime factorization", :answer => "the prime factorization of a number is the expression of the number as the product of its prime factors", :deck_id => deck.id)
    
    Card.create(:question => "prime number", :answer => "a prime is an integer greater than 1 with only two positive factors, 1 and itself", :deck_id => deck.id)
    Card.create(:question => "rational number", :answer => "a rational number is any number you can write as a quotient of two integers, a divided by b, where b isnt zero", :deck_id => deck.id)
    Card.create(:question => "scientific notation", :answer => "scientific number is a way of expressing a number. a number is expressed in scientific notation when it is written as the product of a number greater then or equal to 1 and less than 10, and a power of 10", :deck_id => deck.id)
    Card.create(:question => "simplest form", :answer => "the simpliest form of a fraction is when the only common factors between the numerator and the demoninator is 1", :deck_id => deck.id)
    Card.create(:question => "standard notation", :answer => "standard notation is the usual form for representing a number", :deck_id => deck.id)
    
    print "Created deck: #{deck_name}, by user #{user.login}\n"
  end
end