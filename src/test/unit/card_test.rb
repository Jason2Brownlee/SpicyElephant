require 'test_helper'

class CardTest < ActiveSupport::TestCase

  fixtures :users, :decks, :cards

  # card crud
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  def test_create
    card = decks(:alphabet).cards.build
    card.question = "hello?"
    card.answer = "world!"
    card.instruction = "just do what i say"
    # valid
    assert card.valid?
    # save
    assert card.save
    # retrieve
    card = decks(:alphabet).cards.find_by_question("hello?")
    assert_not_nil card
    assert_equal "world!", card.answer
    assert_equal "just do what i say", card.instruction
    assert_equal decks(:alphabet), card.deck
  end
  
  def test_retrieve
    a = Card.find_by_question "a"
    assert_not_nil a
    assert_not_nil a.question
    assert_not_nil a.answer
    assert_not_nil a.instruction
    assert_not_nil a.deck

    b = Card.find_by_question "b"
    assert_not_nil b
    assert_not_nil b.question
    assert_not_nil b.answer
    assert_not_nil b.instruction
    assert_not_nil b.deck
  end
  
  def test_update
    a = Card.find_by_question "a"
    assert_not_nil a
    # question
    assert a.update_attributes(:question=>"blurg")
    assert a.reload
    assert_equal "blurg", a.question
    # answer
    assert a.update_attributes(:answer=>"blurg")
    assert a.reload
    assert_equal "blurg", a.answer
    # instruction
    assert a.update_attributes(:instruction=>"blurg")
    assert a.reload
    assert_equal "blurg", a.instruction
  end
  
  def test_destroy_deck
    a = Card.find_by_question "a"
    assert_not_nil a
    assert a.destroy
    a = Card.find_by_question "a"
    assert_nil a
  end



  # card question
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  def test_question_not_nil
    a = Card.find_by_question "a"
    assert_not_nil a
    a.question = nil
    assert !a.valid?
    assert !a.save
    assert a.errors.invalid?(:question)
  end
  
  def test_question_not_blank
    a = Card.find_by_question "a"
    assert_not_nil a
    a.question = " \n"    
    assert !a.valid?
    assert !a.save
    assert a.errors.invalid?(:question)
  end

  def test_question_min_length
    a = Card.find_by_question "a"
    assert_not_nil a
    n = "1"
    a.question = n
    assert a.valid?
    assert a.save
  end
  
  # card answer
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  def test_answer_not_nil
    a = Card.find_by_question "a"
    assert_not_nil a
    a.answer = nil
    assert !a.valid?
    assert !a.save
    assert a.errors.invalid?(:answer)
  end
  
  def test_answer_not_blank
    a = Card.find_by_question "a"
    assert_not_nil a
    a.answer = " \n"    
    assert !a.valid?
    assert !a.save
    assert a.errors.invalid?(:answer)
  end

  def test_answer_min_length
    a = Card.find_by_question "a"
    assert_not_nil a
    n = "1"
    a.answer = n
    assert a.valid?
    assert a.save
  end
  
  
  # card instruction
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  def test_instruction_allow_nil
    a = Card.find_by_question "a"
    assert_not_nil a
    a.instruction = nil
    assert a.valid?
    assert a.save
  end
  
  def test_instruction_allow_blank
    a = Card.find_by_question "a"
    assert_not_nil a
    a.instruction = " \t"
    assert a.valid?
    assert a.save
  end

  def test_instruction_too_long
    a = Card.find_by_question "a"
    assert_not_nil a
    # 256
    n = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456"
    a.instruction = n
    assert !a.valid?
    assert !a.save
    assert a.errors.invalid?(:instruction)
  end
  
  def test_instruction_max_length
   a = Card.find_by_question "a"
    assert_not_nil a
    # 255
    n = "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345"
    a.instruction = n
    assert a.valid?
    assert a.save
  end

  def test_instruction_min_length
    a = Card.find_by_question "a"
    assert_not_nil a
    n = "1"
    a.instruction = n
    assert a.valid?
    assert a.save
  end


end
