class SearchController < ApplicationController
	
  # current_tab :decks

  def index 
    @decks = Deck.search(params[:search], params[:page])
  end
end
