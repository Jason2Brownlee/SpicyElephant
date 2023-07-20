class DecksController < ApplicationController
  
  # ensure the user is logged in
  before_filter :login_required, :except => [:show, :index, :subscribers]
  # ensure the user has permission to change/action
  before_filter :check_visibility, :only => [:show, :copy, :recommend]
  # ensure the user is the author 
  before_filter :check_author, :only => [:edit, :update, :destroy]
  
    
  # GET /decks
  # GET /decks.xml
  def index
  	find_params = order_by
    @order = params[:order]
  	if params[:order] == nil || params[:order] == 'popular'
  		@decks = Deck.popular.paginate(:page=>params[:page], :count=>{:group => "decks.id"})
      @order = 'popular'
  	else
      if find_params.blank?
        @decks = Deck.public_visibility.paginate :page => params[:page]
      else
        @decks = Deck.public_visibility.paginate :order => find_params, :page => params[:page]
      end
	  end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @decks }
    end
  end

  # GET /decks/1
  # GET /decks/1.xml
  def show
    @deck = Deck.find(params[:id]) if @deck.nil?
    # TODO might be a performance issue as entire collection loaded in memory before pagination
    @cards = @deck.cards.paginate(:page => params[:page], :per_page => 10)
    # @subscribed_users = @deck.users.find(:all, :select=>"users.*, COUNT(ruminations.id) ruminations_count", :include => :ruminations, :order=>"ruminations.created_at DESC", :group=>"users.id", :limit=>5)  
    @subscribed_users = User.find_by_sql ["SELECT users.*, COUNT(ruminations.id) ruminations_count FROM `users` LEFT OUTER JOIN `study_sessions` ON (`users`.`id` = `study_sessions`.`user_id`) LEFT OUTER JOIN `ruminations` ON (`ruminations`.`study_session_id` = `study_sessions`.`id`) LEFT OUTER JOIN `cards` ON `cards`.id = `ruminations`.card_id INNER JOIN curriculums ON users.id = curriculums.user_id WHERE ((`curriculums`.deck_id = ?) and cards.deck_id=?) GROUP BY users.id ORDER BY ruminations_count DESC, login ASC LIMIT 5", @deck.id, @deck.id]
  
    respond_to do |format|
      format.html     # index.html.erb (no data required)
      # format.ext_json { render :json => @deck.cards.to_ext_json(:class => :cards, :count => @deck.cards.size) }
    end
  end

  # GET /decks/new
  # GET /decks/new.xml
  def new
    @deck = current_user.decks.build
    # show as public by default
    @deck.visibility = Deck::Visibility::Public

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @deck }
    end
  end

  # GET /decks/1/edit
  def edit
    @deck = current_user.decks.find(params[:id]) if @deck.nil?
    @page = params[:page]
  end

  # POST /decks
  # POST /decks.xml
  def create
    @deck = current_user.decks.build(params[:deck])
    # force public by default
    if !current_user.has_subscribed_role?
      @deck.visibility = Deck::Visibility::Public
    else
      # cannot mass assign
      @deck.visibility = params[:deck][:visibility]
    end

    respond_to do |format|
      if @deck.save
        # try and add to the curriculum
        if current_user.add_deck_to_curriculum?(@deck)
          flash[:notice] = 'Deck was successfully created, and added to your curriculum.'
        else
           flash[:notice] = 'Deck was successfully created, but could not be added to your curriculum.'
        end
        
        # action
        Activity.user_created_deck(current_user, @deck)
        
        format.html { redirect_to(@deck) }
        format.xml  { render :xml => @deck, :status => :created, :location => @deck }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @deck.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /decks/1
  # PUT /decks/1.xml
  def update
    @deck = current_user.decks.find(params[:id]) if @deck.nil?
    respond_to do |format|
      if @deck.update_attributes(params[:deck])
        flash[:notice] = 'Deck was successfully updated.'
        format.html { redirect_to(@deck) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @deck.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /decks/1
  # DELETE /decks/1.xml
  def destroy
    @deck = current_user.decks.find(params[:id]) if @deck.nil?    
    @deck.destroy

    respond_to do |format|
      format.html { redirect_to(profile_path) }
      format.xml  { head :ok }
    end
  end
  
  # list all users for a deck
  def subscribers
    @deck = Deck.find(params[:id]) if @deck.nil?
    # @users = @deck.users.paginate(:select=>"users.*, count(ruminations.id) as ruminations_count", :order =>"ruminations_count DESC", :include => :ruminations, :page => params[:page])
    @users = User.paginate_by_sql ["SELECT users.*, COUNT(ruminations.id) ruminations_count FROM `users` LEFT OUTER JOIN `study_sessions` ON (`users`.`id` = `study_sessions`.`user_id`) LEFT OUTER JOIN `ruminations` ON (`ruminations`.`study_session_id` = `study_sessions`.`id`) LEFT OUTER JOIN `cards` ON `cards`.id = `ruminations`.card_id INNER JOIN curriculums ON users.id = curriculums.user_id WHERE ((`curriculums`.deck_id = ?) and (cards.deck_id=?)) GROUP BY users.id ORDER BY ruminations_count DESC, login ASC", @deck.id, @deck.id], :page=>params[:page]
    respond_to do |format|
      format.html 
      format.xml  { render :xml => {@deck, @users} }
    end
  end
  
  # copy a deck
  def copy
    @deck = Deck.find(params[:id])
    newdeck = @deck.user_clone(current_user)
    newdeck.name = @deck.name + ' (copy)'
    
    respond_to do |format|
      if newdeck.save
        @deck = newdeck
        # try and add to the curriculum
        if current_user.add_deck_to_curriculum?(@deck)
          flash[:notice] = 'Deck was successfully copied, and added to your curriculum.'
        else
          flash[:notice] = 'Deck was successfully copied, but could not be added to your curriculum.'
        end
        format.html { redirect_to(@deck) }
        format.xml  { render :xml => @deck, :status => :created, :location => @deck }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @deck.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # recommend this deck to a friend
  def recommend
    @deck = Deck.find(params[:id])
    
    if request.post?
      @recommend = Feedback.new(params['recommend'])
      # validation
      if @recommend.save
        begin
          UserMailer::deliver_recommend_message(@recommend, @deck, current_user)
          flash[:notice] = "Your friend has been notified of about deck #{@deck.name}."
          Activity.user_recommend_deck(current_user, @deck)
          redirect_to @deck
        rescue
          flash[:notice] = "There was a problem sending the message"
          render :action => "recommend"
        end
      else
        # display error messages
        render :action=>"recommend"
      end
    else
      # entry 
      @recommend = Recommend.new
    end
  end
  

  
  
  
  private
  
  # protection - only view deck is visible
  def check_visibility
    check_deck_visibility(Deck.find(params[:id]))
  end
  
  # protection - only manage deck if author
  def check_author
    check_deck_author(Deck.find(params[:id]))
  end
  
end
