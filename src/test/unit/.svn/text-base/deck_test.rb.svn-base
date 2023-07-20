require 'test_helper'

class DeckTest < ActiveSupport::TestCase

  fixtures :users, :decks, :cards

  # deck crud
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  def test_create_deck
    deck = users(:quentin).decks.build
    deck.name = "blurg"
    deck.description = "hello world"
    deck.instruction = "just do what i say"
    deck.visibility = "public"
    # valid
    assert deck.valid?
    # save
    assert deck.save
    # retrieve
    deck = users(:quentin).decks.find_by_name("blurg")
    assert_not_nil deck
    assert_equal "hello world", deck.description
    assert_equal "just do what i say", deck.instruction
    assert_equal "public", deck.visibility
    assert_equal users(:quentin).id, deck.user_id
  end
  
  def test_retrieve_deck
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    assert_not_nil alpha.name
    assert_not_nil alpha.description
    assert_not_nil alpha.instruction
    assert_not_nil alpha.visibility
    assert_not_nil alpha.user
    assert_equal 6, alpha.cards.count
    
    num = Deck.find_by_name "numbers"
    assert_not_nil num
    assert_not_nil num.name
    assert_not_nil num.description
    assert_not_nil num.instruction
    assert_not_nil num.visibility
    assert_not_nil num.user
    assert_equal 6, num.cards.count
  end
  
  def test_update_deck
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    # name
    assert alpha.update_attributes(:name=>"blurg")
    assert alpha.reload
    assert_equal "blurg", alpha.name
    # description
    assert alpha.update_attributes(:description=>"blurg")
    assert alpha.reload
    assert_equal "blurg", alpha.description
    # instruction
    assert alpha.update_attributes(:instruction=>"blurg")
    assert alpha.reload
    assert_equal "blurg", alpha.instruction
  end
  
  def test_destroy_deck
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    assert alpha.destroy
    alpha = Deck.find_by_name "alphabet"
    assert_nil alpha
  end

  # deck name
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  def test_deck_name_not_nil
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.update_attributes(:name=>nil)
    assert !alpha.valid?
    assert !alpha.save
    assert alpha.errors.invalid?(:name)
  end
  
  def test_deck_name_not_blank
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.update_attributes(:name=>" \t")
    assert !alpha.valid?
    assert !alpha.save
    assert alpha.errors.invalid?(:name)
  end

  def test_deck_name_too_long
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    # 256
    n = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456"
    alpha.update_attributes(:name=>n)
    assert !alpha.valid?
    assert !alpha.save
    assert alpha.errors.invalid?(:name)
  end
  
  def test_name_max_length
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    # 255
    n = "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345"
    alpha.update_attributes(:name=>n)
    assert alpha.valid?
    assert alpha.save
  end

  def test_name_min_length
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    n = "1"
    alpha.update_attributes(:name=>n)
    assert alpha.valid?
    assert alpha.save
  end

  # deck description
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  def test_description_not_nil
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.description = nil
    assert !alpha.valid?
    assert !alpha.save
    assert alpha.errors.invalid?(:description)
  end
  
  def test_description_not_blank
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.description = " \n"    
    assert !alpha.valid?
    assert !alpha.save
    assert alpha.errors.invalid?(:description)
  end

  def test_description_min_length
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    n = "1"
    alpha.description = n
    assert alpha.valid?
    assert alpha.save
  end

  # deck visibility
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  def test_visibility_public
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.visibility = "public"
    assert alpha.valid?
    assert alpha.save
    assert alpha.is_public?
  end
  
  def test_visibility_private
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.visibility = "private"
    assert alpha.valid?
    assert alpha.save
    assert !alpha.is_public?
  end
  
  def test_visibility_cannot_change_mass_assignment
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.visibility = "public"
    assert alpha.valid?
    assert alpha.save
    assert alpha.is_public?
    # does not stick
    assert alpha.update_attributes(:visibility=>"private")
    assert alpha.save
    assert alpha.reload
    assert alpha.is_public?
    # does not stick
    assert alpha.attributes = {:visibility=>"private"}
    assert alpha.save
    assert alpha.reload
    assert alpha.is_public?
  end
  
  def test_visibility_not_public_or_private
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.visibility = "publiccc"
    assert !alpha.valid?
    assert !alpha.save
    assert alpha.errors.invalid?(:visibility)
  end
  
  def test_visibility_not_blank
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.visibility = " \t"
    assert !alpha.valid?
    assert !alpha.save
    assert alpha.errors.invalid?(:visibility)
  end
  
  def test_visibility_not_nil
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.visibility = nil
    assert !alpha.valid?
    assert !alpha.save
    assert alpha.errors.invalid?(:visibility)
  end
  
  def test_is_author
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    assert alpha.is_author?(users(:quentin))
    assert !alpha.is_author?(users(:aaron))
    assert !alpha.is_author?(nil)    
  end
  
  def test_cand_edit
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    assert alpha.is_author?(users(:quentin))
    assert !alpha.is_author?(users(:aaron))
    assert !alpha.is_author?(nil)
  end
  
  def test_private_visible_to_author_but_not_other
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.visibility = "private"
    assert alpha.save
    assert alpha.is_visible?(users(:quentin))
    assert !alpha.is_visible?(users(:aaron))
    assert !alpha.is_visible?(nil)
  end
  
  
  # visibility and named scopes
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
  def test_private_not_in_recent
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.visibility = "private"
    assert alpha.save
    alpha = Deck.recent.find_by_name "alphabet"
    assert_nil alpha 
  end
  
  def test_private_not_in_public_visibility
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.visibility = "private"
    assert alpha.save
    alpha = Deck.public_visibility.find_by_name "alphabet"
    assert_nil alpha 
  end
  
  def test_private_not_in_public_byname
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.visibility = "private"
    assert alpha.save
    alpha = Deck.byname.find_by_name "alphabet"
    assert_nil alpha 
  end
  
  def test_private_not_in_hot
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.visibility = "private"
    assert alpha.save
    alpha = Deck.hot.find_by_name "alphabet"
    assert_nil alpha 
  end
  
  def test_private_not_in_popular
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.visibility = "private"
    assert alpha.save
    alpha = Deck.popular.find_by_name "alphabet"
    assert_nil alpha
  end


  # deck instruction
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  def test_instruction_allow_nil
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.instruction = nil
    assert alpha.valid?
    assert alpha.save
  end
  
  def test_instruction_allow_blank
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.instruction = " \t"
    assert alpha.valid?
    assert alpha.save
  end

  def test_instruction_too_long
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    # 256
    n = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456"
    alpha.instruction = n
    assert !alpha.valid?
    assert !alpha.save
    assert alpha.errors.invalid?(:instruction)
  end
  
  def test_instruction_max_length
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    # 255
    n = "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345"
    alpha.instruction = n
    assert alpha.valid?
    assert alpha.save
  end

  def test_instruction_min_length
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    n = "1"
    alpha.instruction = n
    assert alpha.valid?
    assert alpha.save
  end


  # deck cards
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  # is this important? - jason, 1/10/2008  
  
  # def test_deck_save_with_invalid_card
  #   alpha = Deck.find_by_name "alphabet"
  #   assert_not_nil alpha
  #   alpha.cards.first.question = nil
  #   alpha.cards.first.answer = nil
  #   assert !alpha.valid?
  #   assert !alpha.save
  # end
  
  # cloning
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
  def test_clone_successful
    alpha = users(:quentin).decks.find_by_name("alphabet")
    assert_not_nil alpha
    assert_nil users(:aaron).decks.find_by_name("alphabet")
    # clone
    alpha_clone = alpha.user_clone(users(:aaron))
    assert_not_nil alpha_clone
    assert alpha_clone.valid?
    assert alpha_clone.save
    assert alpha_clone.reload
    # ensure ownership 
    assert_equal users(:aaron), alpha_clone.user
    assert_equal users(:quentin), alpha.user
    # ensure critical data matches
    assert_equal alpha.name, alpha_clone.name
    assert_equal alpha.description, alpha_clone.description
    assert_equal alpha.instruction, alpha_clone.instruction
    assert_equal alpha.visibility, alpha_clone.visibility
    assert_equal alpha.cards.count, alpha_clone.cards.count
    # ensure card belongs to the correct deck
    alpha.cards.each { |card| assert_equal alpha, card.deck } 
    alpha_clone.cards.each { |card| assert_equal alpha_clone, card.deck }
  end
  
  def test_cannot_clone_private
    alpha = Deck.find_by_name "alphabet"
    assert_not_nil alpha
    alpha.visibility = "private"
    assert alpha.save
    alpha_clone = alpha.user_clone(users(:aaron))
    assert_nil alpha_clone
  end
  
end
