require 'csv'

class CardsController < ApplicationController
  
  # always load the associated deck
  before_filter :load_deck
  # must always be logged in
  before_filter :login_required, :except => [:export_csv]
  # must be author to manipuate cards - all action
  before_filter :check_author, :except => [:export_csv]
  
  # GET /cards
  # GET /cards.xml
  def index
    # not supported
    redirect_to root_path
  end

  # GET /cards/1
  # GET /cards/1.xml
  def show
    # not supported
    redirect_to root_path
  end

  # GET /cards/new
  # GET /cards/new.xml
  def new
    # if params[:card]
    #   create
    #   return
    # end
    
    @card = @deck.cards.build
    @card.instruction = @deck.instruction

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @card }
    end
  end

  # POST /cards
  # POST /cards.xml
  def create    
    @card = @deck.cards.build(params[:card])
    respond_to do |format|
      if @card.save
        # if params[:mc] && params[:mc][:ismc] && params[:mc][:ismc]=='on'
        #   @card.multi_choice_options.create(:option => params[:mc]['1']);
        #   @card.multi_choice_options.create(:option => params[:mc]['2']);
        #   @card.multi_choice_options.create(:option => params[:mc]['3']);
        #   @card.multi_choice_options.create(:option => params[:mc]['4']);
        # end
        flash[:notice] = 'Card was successfully created.'
        format.html { redirect_to new_deck_card_path(@deck) }
        format.xml  { render :xml => @card, :status => :created, :location => @card }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @card.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  # GET /cards/1/edit
  def edit
    @card = @deck.cards.find(params[:id])
    @page = params[:page]
  end

  # PUT /cards/1
  # PUT /cards/1.xml
  def update
    @card = @deck.cards.find(params[:id])
    
    respond_to do |format|
      if @card.update_attributes(params[:card])
        flash[:notice] = 'Card was successfully updated.'
        format.html { redirect_to(:controller => 'decks', :action => 'show', :id => @deck, :page => params[:page]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @card.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.xml
  def destroy    
    @card = @deck.cards.find(params[:id])
    @card.destroy

    respond_to do |format|
      format.html { redirect_to(@deck) }
      format.xml  { head :ok }
    end
  end
  
  
  # upload csv of cards
  def upload_csv    
    if request.post?
      @parsed_file=CSV::Reader.parse(params[:upload][:filedata])
      # basic checking
      if @parsed_file.blank?
        flash[:notice]="Sorry, your file contained no records"
        redirect_to @deck        
        return
      end 
      n = 0
      @parsed_file.each do |row|
           card = @deck.cards.build
           card.question=row[0]
           card.answer=row[1]
           # simply skip invalid
           if card.save
              n = n+1
           end
      end
      flash[:notice]="CSV Upload Successful, #{n} new cards added to deck"
      redirect_to @deck
    else
      # render
    end
  end
  
  # download all cards as csv
  def export_csv
    if !@deck.is_visible?(current_user)
      flash[:notice] = 'Sorry, you do not have permission to view this deck.'
      redirect_to root_path
      return
    end
    
    @cards = @deck.cards
    response.headers['Content-Type'] = 'text/csv; charset=iso-8859-1; header=present'
    response.headers['Content-Disposition'] = 'attachment; filename=cards_export.csv'
    render :action => :export_csv, :layout => false
  end
  
  
  
  private
  
  # load the deck
  def load_deck
    @deck = Deck.find(params[:deck_id])
  end
  
  # protection - only manage deck if author
  def check_author
    check_deck_author(@deck)
  end
  
end