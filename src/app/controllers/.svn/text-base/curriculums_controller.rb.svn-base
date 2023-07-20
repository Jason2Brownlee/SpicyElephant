class CurriculumsController < ApplicationController
  
  # always load the associated user
  before_filter :login_required
  
  # add to curriculum
  def create
    @deck = Deck.find(params[:deck])
    
    if !current_user.add_deck_to_curriculum?(@deck)
      flash[:notice] = 'Deck could not be added to curriculum.'
      redirect_to(train_path)
    else 
      flash[:notice] = 'Deck was successfully added to curriculum.'
      event_new_curriculum(@deck)
      redirect_to(train_path)
    end
  end

  # remove from curriculum
  def destroy
    @deck = Deck.find(params[:deck])
    @curriculum = current_user.curriculums.find_by_deck_id(@deck.id)
    unless @curriculum.nil?
      @curriculum.destroy
      delete_states(@deck)
    
      respond_to do |format|
        flash[:notice] = 'Deck was successfully removed from curriculum.'
        format.html { redirect_to(train_path) }
        format.xml  { head :ok }
      end
    else
      return false
    end
  end
  
  
  
  private
  
  def event_new_curriculum(deck)
    #initialize the deck under the leitner system
    SupermemoState.init(current_user, deck)
    # activity
    Activity.user_added_deck_to_curriculum(current_user, deck)
  end

  def delete_states(deck)
    # delete supermemo states associated with the deck
    for state in current_user.supermemo_states.find(:all, :conditions => ["cards.deck_id=?", deck.id], :include => :card)
      state.destroy
    end
  end

end
