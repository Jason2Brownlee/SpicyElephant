class MessagesController < ApplicationController
  
  # always load the associated deck
  before_filter :load_deck
  before_filter :login_required, :except => [:index]
  before_filter :check_visibility, :except => [:index]
    
  # GET /messages
  # GET /messages.xml
  def index
    @messages = Message.paginate(:all, :conditions => ['deck_id = ?', @deck.id],:order => 'created_at DESC', :page => params[:page])
    if (logged_in?)
      @message = @deck.messages.build
      @message.user = current_user
    end    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = @deck.messages.build
    @message.user = current_user

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.xml
  def create
    #@message = Message.new(params[:message])
    @message = @deck.messages.build(params[:message])
    @message.user = current_user

    respond_to do |format|
      if @message.save
        # put in activity stream
        Activity.user_messaged_deck(current_user, @deck)
        flash[:notice] = 'Message was successfully posted.'
        format.html { redirect_to(deck_messages_path(@deck)) }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { redirect_to(deck_messages_path(@deck)) }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end
  
  
  private
  
  def load_deck
      @deck = Deck.find(params[:deck_id])
  end
  
  # protection to ensure only add messages if deck is visible
  def check_visibility
    check_deck_visibility(@deck)
  end
  
end
