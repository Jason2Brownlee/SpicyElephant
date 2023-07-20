class TrainController < ApplicationController
  
  # load the study session
  before_filter :load_session, :except => [:train, :ruminate_start]
  # load the deck being studied
  before_filter :load_deck, :only => [:train, :ruminate_start]
  # ensure the deck is visible (either directly or through the session)
  before_filter :deck_visibility
  # check for session hacking / hijacking
  before_filter :session_hacking_check, :only  => [:ruminate, :result, :finish]
  
  #Have trouble ruminating without this for some reason.
  protect_from_forgery :except => [:ruminate]

  
  # hack for getting people to pay
  before_filter :check_must_upgrade

  def train2
    # pass through
  end

  # landing page for users training state, or # train on a specific deck
  def train
    # automatically add deck to curriculum
    if !@deck.nil? and logged_in?
      # check if not in curriculum
      if !current_user.curriculums.exists?(:deck_id => @deck)
        # try and add to curriculum
        if !current_user.add_deck_to_curriculum?(@deck)
          flash[:notice] = 'Deck could not be added to curriculum.'
          redirect_to(profile_path)
          return
        else 
          flash[:notice] = 'Deck was successfully added to curriculum.'
          Activity.user_added_deck_to_curriculum(current_user, @deck)
        end
      end
    end
    
    # prepare states
    if logged_in?
      SupermemoState.init(current_user, @deck)
    end
    
    # calculate mode for entire curriculum
    @study_mode = study_mode_for_deck
    # in the case of a deck, redirect now
    if @deck
      redirect_to train_ruminate_start_path(:study_mode => @study_mode, :deck => @deck)
    else 
      if authorized?
        # calculate the cards remaining (ALL MODE!), and render nicely
        @cards_remaining = current_user.cards_remaining
        @cards_total = current_user.total_cards
      else
        access_denied
      end
    end
  end
  

  

  # start of rumination, creates session, redirects to first rumination
  def ruminate_start
    study_mode = StudyMode.find(params[:study_mode])
    # create a session
    if logged_in?
      @study_session = current_user.study_sessions.build(:study_mode => study_mode, :deck => @deck)
    else
      @study_session = StudySession.create(:study_mode => study_mode, :deck => @deck)
    end
    @study_session.save!
    # check for review mode
    if logged_in? and @study_session.study_mode.is_review?
      flash[:notice] = "You have no scheduled cards, reviewing all cards."  
    end
    # redirect to first rumination
    redirect_to train_ruminate_path(:study_session=>@study_session, :format => 'html')
  end
  
  
  # expose the user to a card and capture their result
  def ruminate
    # check for finish
    @cards_remaining = @study_session.cards_remaining
    
    # next card always come from the session (rather than url)
    @cards = @study_session.next_cards
    @deck = @study_session.deck
        
    if (@cards_remaining <= 0)
      respond_to do |format|
        format.html { return redirect_to(train_finish_path(:study_session => @study_session)) }
        format.js { render(:update) { |page| page.redirect_to(train_finish_path(:study_session => @study_session)) } }
      end  
      return
    end

    # possible result set
    @possible_results = RuminationResult.all_results 
    # render ruminate
    respond_to do |format|
      format.html { }
      format.js  { render :action => "runimate.js.rjs", :locals => :notice }
    end    
  end

  # capture the card result and push to the next card or finish
  def result
    # pull parameters - must exist otherwise 404
    card = Card.find(params[:card])
    result = RuminationResult.find(params[:result])

    # save result
    @study_session.submit_result(card, result)
    #flash[:notice] = "A #{result} result was recorded"
    # push back to ruminate
    respond_to do |format|
      format.html {redirect_to train_ruminate_path(:study_session=>@study_session, :deck=>@deck)}
      #format.js {redirect_to ajax_train_ruminate_path(:study_session=>@study_session, :deck=>@deck)}
      format.js {ruminate}
    end
  end

  # summarise the training session
  def finish
    #activities
    @study_session.finish
    @positive_results = @study_session.count_positive_results
    @negative_results = @study_session.count_negative_results
    @total_results = (@positive_results + @negative_results)
  end
  
  private
  def session_hacking_check
    # basic protection against hacking session id's
    if !@study_session.user.nil?
      if !logged_in? or current_user.id != @study_session.user.id
        redirect_to root_path
      end
    end 
  end
  
  # load the current deck being studied
  def load_deck
    @deck = Deck.find(params[:deck]) if !params[:deck].nil?
  end
  
  # load the current study session
  def load_session
    # always try and load the study session, otherwise error
    @study_session = StudySession.find(params[:study_session])
  end
  
  # ensure deck is visible when studing a deck
  def deck_visibility
    # for train and ruminate_start (if studing a deck)
    check_deck_visibility(@deck) if !@deck.nil?
    # for ruminate, result, finish (if studying a deck)
    check_deck_visibility(@study_session.deck) if (!@study_session.nil? and !@study_session.deck.nil?)
  end
  
  # helper, selects a study mode for the current state of training
  # for all mode and per deck mode
  def study_mode_for_deck
    if logged_in? and current_user.study_mode.user_has_cards_for_review?(current_user,  @deck)
      study_mode = current_user.study_mode
    else
      study_mode = StudyMode.review_mode
    end
  end

  def check_must_upgrade
    # must be logged in
    return if !logged_in?
    # must not be subscribed
    return if current_user.has_subscribed_role?
    # check if maximum cards exceeded
    if current_user.current_supermemo_ruminations >= 50
      flash[:notice] = 'Sorry, you must upgrade to preimum to study.'
      redirect_to root_path
    end
  end

end
