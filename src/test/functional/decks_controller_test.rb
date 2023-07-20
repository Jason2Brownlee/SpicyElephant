require 'test_helper'
include AuthenticatedTestHelper

class DecksControllerTest < ActionController::TestCase
  fixtures :users, :decks, :cards, :roles, :permissions, :curriculums
  
  # logged in - normal cases
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  def test_should_get_index
    login_as (:quentin)
    get :index
    assert_response :success
    assert_not_nil assigns(:decks)
  end

  def test_should_get_new
    login_as (:quentin)
    get :new
    assert_response :success
    assert_not_nil assigns(:deck)
  end

  def test_should_create_deck
    login_as (:quentin)
    assert_equal 2, users(:quentin).curriculums.count
    assert !users(:quentin).has_subscribed_role?
    assert_difference('Deck.count') do
      post :create, :deck => {:name=>"blerg", :description=>"a description", :instruction=>"do what i say"}
    end
    assert_redirected_to deck_path(assigns(:deck))
    # ensure deck is public
    deck = Deck.find_by_name "blerg"
    assert deck
    assert deck.is_public?
    assert_equal "blerg", deck.name
    assert_equal "a description", deck.description
    assert_equal "do what i say", deck.instruction
    # ensure added to curriculum
    assert_equal 3, users(:quentin).curriculums.count
    assert_not_nil users(:quentin).curriculums.find_by_deck_id(deck.id)
  end
  
  def test_should_create_deck_not_private
    login_as (:quentin)
    assert !users(:quentin).has_subscribed_role?
    assert_difference('Deck.count') do
      post :create, :deck => {:name=>"blerg", :description=>"a description", :instruction=>"do what i say", :visibility=>"private"}
    end
    assert_redirected_to deck_path(assigns(:deck))
    # ensure deck is public
    deck = Deck.find_by_name "blerg"
    assert deck
    assert deck.is_public?
    assert_equal "blerg", deck.name
    assert_equal "a description", deck.description
    assert_equal "do what i say", deck.instruction
    # ensure added to curriculum
    assert_not_nil users(:quentin).curriculums.find_by_deck_id(deck.id)
  end
  
  def test_subscribed_can_create_public_deck
    # tom is subscribed
    login_as (:tom)
    assert users(:tom).has_subscribed_role?
    assert_difference('Deck.count') do
      post :create, :deck => {:name=>"blerg", :description=>"a description", :instruction=>"do what i say", :visibility=>"public"}
    end
    assert_redirected_to deck_path(assigns(:deck))
    # ensure deck is public
    deck = Deck.find_by_name "blerg"
    assert deck
    assert deck.is_public?
    assert_equal "blerg", deck.name
    assert_equal "a description", deck.description
    assert_equal "do what i say", deck.instruction
    # ensure added to curriculum
    assert_not_nil users(:tom).curriculums.find_by_deck_id(deck.id)
  end
  
  def test_subscribed_can_create_private_deck
    # tom is subscribed
    login_as (:tom)
    assert users(:tom).has_subscribed_role?
    assert_difference('Deck.count') do
      post :create, :deck => {:name=>"blerg", :description=>"a description", :instruction=>"do what i say", :visibility=>"private"}
    end
    assert_redirected_to deck_path(assigns(:deck))
    # ensure deck is public
    deck = Deck.find_by_name "blerg"
    assert deck
    assert !deck.is_public?
    assert_equal "private", deck.visibility
    assert_equal "blerg", deck.name
    assert_equal "a description", deck.description
    assert_equal "do what i say", deck.instruction
    # ensure added to curriculum
    assert_not_nil users(:tom).curriculums.find_by_deck_id(deck.id)
  end
  
  def test_should_create_cannot_add_to_curriculum
    login_as (:aaron)
    assert_equal 0, users(:aaron).curriculums.count
    5.times do 
      d = users(:aaron).decks.build
      d.attributes = {:name=>"asd",:description=>"asd"}
      d.visibility="public"
      assert d.save
      c = users(:aaron).curriculums.build
      c.attributes = {:deck=>d}
      assert c.save
    end
    assert_equal 5, users(:aaron).curriculums.count
    assert !users(:aaron).has_subscribed_role?
    assert_difference('Deck.count') do
      post :create, :deck => {:name=>"blerg", :description=>"a description", :instruction=>"do what i say"}
    end
    assert_redirected_to deck_path(assigns(:deck))
    # ensure deck is public
    deck = Deck.find_by_name "blerg"
    assert deck
    assert deck.is_public?
    assert_equal "blerg", deck.name
    assert_equal "a description", deck.description
    assert_equal "do what i say", deck.instruction
    # ensure NOT added to curriculum
    assert !users(:aaron).curriculums.find_by_deck_id(deck.id)
    assert_equal 5, users(:aaron).curriculums.count
  end

  def test_should_show_deck
    login_as (:quentin)
    get :show, :id => decks(:alphabet).id
    assert_response :success
    assert_not_nil assigns(:deck)
    assert_not_nil assigns(:cards)
  end

  def test_should_get_edit
    login_as (:quentin)
    get :edit, :id => decks(:alphabet).id
    assert_response :success
    assert_not_nil assigns(:deck)
  end

  def test_should_update_deck
    login_as (:quentin)
    put :update, :id => decks(:alphabet).id, :deck => {:name=>"blerg", :description=>"a new description", :instruction=>"do what i say"}
    assert_redirected_to deck_path(assigns(:deck))
    deck = Deck.find_by_name "blerg"
    assert deck
    assert deck.is_public?
    assert_equal "blerg", deck.name
    assert_equal "a new description", deck.description
    assert_equal "do what i say", deck.instruction
  end

  def test_should_destroy_deck
    login_as (:quentin)
    assert_difference('Deck.count', -1) do
      delete :destroy, :id => decks(:alphabet).id
    end
    assert_redirected_to profile_path
    assert_nil Deck.find_by_name("alphabet")
  end
  
  def test_should_list_subscribers
    login_as (:quentin)
    get :subscribers, :id => decks(:alphabet).id
    assert_response :success
    assert_not_nil assigns(:deck)
    assert_not_nil assigns(:users)
  end
  
  def test_should_copy
    login_as (:aaron)
    assert_nil users(:aaron).decks.find_by_name("alphabet")
    assert_nil users(:aaron).decks.find_by_name("alphabet (copy)")
    assert_difference('Deck.count') do
      get :copy, :id => decks(:alphabet).id
    end
    assert_redirected_to deck_path(assigns(:deck))
    # ensure we go to the copy    
    assert_equal users(:aaron), assigns(:deck).user
    # ensure copy was saved
    assert_nil users(:aaron).decks.find_by_name("alphabet")    
    deck = users(:aaron).decks.find_by_name("alphabet (copy)")
    assert_not_nil deck
    # ensure added to curriculm
    assert users(:aaron).curriculums.find_by_deck_id(deck.id)
  end
  
  def test_should_copy_cannot_add_to_curriculum
    login_as (:aaron)
    assert_equal 0, users(:aaron).curriculums.count
    5.times do 
      d = users(:aaron).decks.build
      d.attributes = {:name=>"asd",:description=>"asd"}
      d.visibility="public"
      assert d.save
      c = users(:aaron).curriculums.build
      c.attributes = {:deck=>d}
      assert c.save
    end
    assert_equal 5, users(:aaron).curriculums.count
    assert !users(:aaron).has_subscribed_role?
    assert_nil users(:aaron).decks.find_by_name("alphabet")
    assert_nil users(:aaron).decks.find_by_name("alphabet (copy)")
    assert_difference('Deck.count') do
      get :copy, :id => decks(:alphabet).id
    end    
    assert_redirected_to deck_path(assigns(:deck))
    # ensure we go to the copy    
    assert_equal users(:aaron), assigns(:deck).user
    # ensure copy was saved
    assert_nil users(:aaron).decks.find_by_name("alphabet")
    deck = users(:aaron).decks.find_by_name("alphabet (copy)")
    assert_not_nil deck
    # ensure NOT added to curriculum
    assert !users(:aaron).curriculums.find_by_deck_id(deck.id)
    assert_equal 5, users(:aaron).curriculums.count
  end
  
  
  
  def test_should_copy_when_author
    login_as (:quentin)
    assert_not_nil users(:quentin).decks.find_by_name("alphabet")
    assert_nil users(:quentin).decks.find_by_name("alphabet (copy)")
    get :copy, :id => decks(:alphabet).id
    assert_redirected_to deck_path(assigns(:deck))
    # ensure we go to the copy    
    assert_equal users(:quentin), assigns(:deck).user
    # ensure copy was saved
    assert_not_nil users(:quentin).decks.find_by_name("alphabet")
    assert_not_nil users(:quentin).decks.find_by_name("alphabet (copy)")
  end
  
  def test_should_recommend
    login_as (:quentin)
    get :recommend, :id => decks(:alphabet).id
    assert_response :success
    assert_not_nil assigns(:deck)
    assert_not_nil assigns(:recommend)
  end
  
  def test_should_make_recommendation
    login_as (:quentin)
    post :recommend, :id => decks(:alphabet).id, :recommend=>{:name=>"test", :email_address=>"test@test.com", :message=>"check this out"}
    assert_redirected_to deck_path(assigns(:deck))
  end

  # authentication / ownership
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
  def test_index_without_login
    get :index
    assert_response :success
    assert_not_nil assigns(:decks)
  end

  def test_should_not_get_new_without_login
    get :new
    assert_redirected_to login_path
  end

  def test_should_not_create_deck_without_login
    post :create, :deck => {:name=>"blerg", :description=>"a description", :instruction=>"do what i say"}
    assert_redirected_to login_path
  end

  def test_should_show_public_deck_without_login
    get :show, :id => decks(:alphabet).id
    assert_response :success
    assert_not_nil assigns(:deck)
    assert_not_nil assigns(:cards)
  end
  
  def test_should_not_show_private_deck_without_login
    deck = decks(:alphabet)
    deck.visibility = "private"
    assert deck.save
    # get
    get :show, :id => decks(:alphabet).id
    assert_redirected_to root_path
  end
  
  def test_should_not_show_private_deck_when_not_author
    deck = decks(:alphabet)
    deck.visibility = "private"
    assert deck.save
    # get
    login_as (:aaron)
    get :show, :id => decks(:alphabet).id
    assert_redirected_to root_path
  end

  def test_should_not_get_edit_without_login
    get :edit, :id => decks(:alphabet).id
    assert_redirected_to login_path
  end
  
  def test_should_not_get_edit_if_not_author
    login_as (:aaron)
    get :edit, :id => decks(:alphabet).id
    assert_redirected_to root_path
  end

  def test_should_not_update_deck_without_login
    put :update, :id => decks(:alphabet).id, :deck => {:name=>"blerg", :description=>"a new description", :instruction=>"do what i say"}
    assert_redirected_to login_path
  end
  
  def test_should_not_update_deck_when_not_author
    login_as (:aaron)
    put :update, :id => decks(:alphabet).id, :deck => {:name=>"blerg", :description=>"a new description", :instruction=>"do what i say"}
    assert_redirected_to root_path
  end

  def test_should_not_destroy_deck_when_not_logged_in
    delete :destroy, :id => decks(:alphabet).id
    assert_redirected_to login_path
  end
  
  def test_should_not_destroy_deck_when_not_author
    login_as (:aaron)
    delete :destroy, :id => decks(:alphabet).id
    assert_redirected_to root_path
  end
  
  def test_should_list_subscribers_when_not_logged_in
    get :subscribers, :id => decks(:alphabet).id
    assert_response :success
    assert_not_nil assigns(:deck)
    assert_not_nil assigns(:users)
  end
  
  def test_should_list_subscribers_when_not_not_author
    login_as (:aaron)
    get :subscribers, :id => decks(:alphabet).id
    assert_response :success
    assert_not_nil assigns(:deck)
    assert_not_nil assigns(:users)
  end
  
  def test_should_not_copy_when_not_logged_in
    assert_nil users(:aaron).decks.find_by_name("alphabet")
    get :copy, :id => decks(:alphabet).id
    assert_redirected_to login_path
  end
  
  def test_should_recommend_when_not_author
    login_as (:aaron)
    get :recommend, :id => decks(:alphabet).id
    assert_response :success
    assert_not_nil assigns(:deck)
    assert_not_nil assigns(:recommend)
  end
  
  def test_should_make_recommendation_when_not_author
    login_as (:aaron)
    post :recommend, :id => decks(:alphabet).id, :recommend=>{:name=>"test", :email_address=>"test@test.com", :message=>"check this out"}
    assert_redirected_to deck_path(assigns(:deck))
  end
  
  # normal failure cases (validation)
  # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
end
