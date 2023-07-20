require 'test_helper'
include AuthenticatedTestHelper

class CardsControllerTest < ActionController::TestCase
  
  fixtures :users, :decks, :cards, :roles, :permissions, :curriculums
  
  
  # logged in - normal cases
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  

  def test_should_not_get_index
    login_as (:quentin)    
    get :index, :deck_id=>decks(:alphabet).id
    assert_redirected_to root_path
  end

  def test_should_get_new
    login_as (:quentin)
    get :new, :deck_id=>decks(:alphabet).id
    assert_response :success
  end

  def test_should_create_card
    login_as (:quentin)
    assert_difference('Card.count') do
      post :create, :deck_id=>decks(:alphabet).id, :card => {:question=>"are you well", :answer=>"yes i am", :instruction=>"just do what i say" }
    end
    assert_redirected_to new_deck_card_path(assigns(:deck))
    card = Card.find_by_question("are you well")
    assert card
    assert_equal "are you well", card.question
    assert_equal "yes i am", card.answer
    assert_equal "just do what i say", card.instruction
  end

  def test_should_not_show_card
    login_as (:quentin)
    get :show, :deck_id=>decks(:alphabet).id, :id => cards(:a).id
    assert_redirected_to root_path
  end

  def test_should_get_edit
    login_as (:quentin)
    get :edit, :deck_id=>decks(:alphabet).id, :id => cards(:a).id
    assert_response :success
  end

  def test_should_update_card
    login_as (:quentin)
    put :update, :deck_id=>decks(:alphabet).id, :id => cards(:a).id, :card => {:question=>"are you well", :answer=>"yes i am", :instruction=>"just do what i say"}
    assert_redirected_to deck_path(assigns(:deck))
    card = Card.find_by_question("are you well")
    assert card
    assert_equal "are you well", card.question
    assert_equal "yes i am", card.answer
    assert_equal "just do what i say", card.instruction
  end

  def test_should_destroy_card
    login_as (:quentin)
    assert_difference('Card.count', -1) do
      delete :destroy, :deck_id=>decks(:alphabet).id, :id => cards(:a).id
    end
    assert_redirected_to deck_path(assigns(:deck))
  end
  
  # upload
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
  def test_get_upload
    login_as (:quentin)
    get :upload_csv, :deck_id=>decks(:alphabet).id
    assert_response :success    
  end
  
  def test_post_upload_simple
    login_as (:quentin)
    deck = users(:quentin).decks.build
    deck.visibility = "public"
    deck.attributes = {:name=>"test", :description=>"hello world", :instruction=>"just do what i say"}
    assert deck.save    
    deck = Deck.find_by_name("test")
    assert_equal 0, deck.cards.count
    post :upload_csv, :deck_id=>deck.id, :upload=>{:filedata=>fixture_file_upload("upload_cards_simple.csv")}
    assert_redirected_to deck_path(assigns(:deck))
    deck = Deck.find_by_name("test")
    assert_equal 13, deck.cards.count
  end
  
  def test_post_upload_quoated
    login_as (:quentin)
    deck = users(:quentin).decks.build
    deck.visibility = "public"
    deck.attributes = {:name=>"test", :description=>"hello world", :instruction=>"just do what i say"}
    assert deck.save    
    deck = Deck.find_by_name("test")
    assert_equal 0, deck.cards.count
    post :upload_csv, :deck_id=>deck.id, :upload=>{:filedata=>fixture_file_upload("upload_cards_quoated.csv")}
    assert_redirected_to deck_path(assigns(:deck))
    deck = Deck.find_by_name("test")
    assert_equal 13, deck.cards.count
  end
  
  def test_post_upload_utf8
    login_as (:quentin)
    deck = users(:quentin).decks.build
    deck.visibility = "public"
    deck.attributes = {:name=>"test", :description=>"hello world", :instruction=>"just do what i say"}
    assert deck.save    
    deck = Deck.find_by_name("test")
    assert_equal 0, deck.cards.count
    post :upload_csv, :deck_id=>deck.id, :upload=>{:filedata=>fixture_file_upload("upload_cards_utf8.csv")}
    assert_redirected_to deck_path(assigns(:deck))
    deck = Deck.find_by_name("test")
    assert_equal 7, deck.cards.count
  end
  
  def test_post_upload_empty
    login_as (:quentin)
    deck = users(:quentin).decks.build
    deck.visibility = "public"
    deck.attributes = {:name=>"test", :description=>"hello world", :instruction=>"just do what i say"}
    assert deck.save    
    deck = Deck.find_by_name("test")
    assert_equal 0, deck.cards.count
    post :upload_csv, :deck_id=>deck.id, :upload=>{:filedata=>"blah"}
    assert_redirected_to deck_path(assigns(:deck))
    deck = Deck.find_by_name("test")
    assert_equal 0, deck.cards.count
  end
  
  # export
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
  
  def test_export_simple
    login_as (:quentin)
    get :export_csv, :deck_id=>decks(:alphabet).id
    assert_response :success
  end
    
  # authentication / ownership
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
  # new
  
  def test_should_not_new_without_login
    get :new, :deck_id=>decks(:alphabet).id
    assert_redirected_to login_path
  end
  
  def test_should_not_new_when_not_author
    login_as (:aaron)    
    get :new, :deck_id=>decks(:alphabet).id
    assert_redirected_to root_path
  end
  
  # create
  
  def test_should_not_create_without_login
    assert_no_difference('Card.count') do
      post :create, :deck_id=>decks(:alphabet).id, :card => {:question=>"are you well", :answer=>"yes i am", :instruction=>"just do what i say" }
    end
    assert_redirected_to login_path
  end
  
  def test_should_not_create_when_not_author
    login_as (:aaron)
    assert_no_difference('Card.count') do
      post :create, :deck_id=>decks(:alphabet).id, :card => {:question=>"are you well", :answer=>"yes i am", :instruction=>"just do what i say" }
    end
    assert_redirected_to root_path
  end
  
  # edit
  
  def test_should_not_edit_without_login
    get :edit, :deck_id=>decks(:alphabet).id, :id => cards(:a).id
    assert_redirected_to login_path
  end
  
  def test_should_not_edit_when_not_author
    login_as (:aaron)
    get :edit, :deck_id=>decks(:alphabet).id, :id => cards(:a).id
    assert_redirected_to root_path
  end
  
  # update
  
  def test_should_not_update_without_login
    put :update, :deck_id=>decks(:alphabet).id, :id => cards(:a).id, :card => {:question=>"are you well", :answer=>"yes i am", :instruction=>"just do what i say"}
    assert_redirected_to login_path
  end
  
  def test_should_not_update_when_not_author
    login_as (:aaron)
    put :update, :deck_id=>decks(:alphabet).id, :id => cards(:a).id, :card => {:question=>"are you well", :answer=>"yes i am", :instruction=>"just do what i say"}
    assert_redirected_to root_path
  end
  
  # destroy
  
  def test_should_not_destroy_without_login
    assert_no_difference('Card.count') do
      delete :destroy, :deck_id=>decks(:alphabet).id, :id => cards(:a).id
    end
    assert_redirected_to login_path
  end
  
  def test_should_not_destroy_when_not_author
    login_as (:aaron)
    assert_no_difference('Card.count') do
      delete :destroy, :deck_id=>decks(:alphabet).id, :id => cards(:a).id
    end
    assert_redirected_to root_path
  end
  
  # upload
  
  def test_should_not_upload_csv_when_not_logged_in
    deck = users(:quentin).decks.build
    deck.visibility = "public"
    deck.attributes = {:name=>"test", :description=>"hello world", :instruction=>"just do what i say"}
    assert deck.save    
    deck = Deck.find_by_name("test")
    assert_equal 0, deck.cards.count
    post :upload_csv, :deck_id=>deck.id, :upload=>{:filedata=>fixture_file_upload("upload_cards_simple.csv")}
    assert_redirected_to login_path
    deck = Deck.find_by_name("test")
    assert_equal 0, deck.cards.count
  end
  
  def test_should_not_upload_csv_when_not_author
    login_as (:aaron)
    deck = users(:quentin).decks.build
    deck.visibility = "public"
    deck.attributes = {:name=>"test", :description=>"hello world", :instruction=>"just do what i say"}
    assert deck.save    
    deck = Deck.find_by_name("test")
    assert_equal 0, deck.cards.count
    post :upload_csv, :deck_id=>deck.id, :upload=>{:filedata=>fixture_file_upload("upload_cards_simple.csv")}
    assert_redirected_to root_path
    deck = Deck.find_by_name("test")
    assert_equal 0, deck.cards.count
  end
  
  # export
  
  def test_should_export_when_not_logged_in
    get :export_csv, :deck_id=>decks(:alphabet).id
    assert_response :success
  end

  def test_should_export_when_not_author
    login_as (:aaron)
    get :export_csv, :deck_id=>decks(:alphabet).id
    assert_response :success
  end
  
  def test_should_not_export_when_not_logged_in_and_deck_is_private
    deck = decks(:alphabet)
    deck.visibility = "private"
    assert deck.save
    assert deck.reload
    get :export_csv, :deck_id=>decks(:alphabet).id
    assert_redirected_to root_path
  end
  
  def test_should_not_export_when_not_author_and_deck_is_private
    login_as (:aaron)
    deck = decks(:alphabet)
    deck.visibility = "private"
    assert deck.save
    assert deck.reload
    get :export_csv, :deck_id=>decks(:alphabet).id
    assert_redirected_to root_path
  end
  
end
